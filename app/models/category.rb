# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id             :uuid             not null, primary key
#  parent_id      :uuid
#  name           :string           not null
#  products_count :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  g_identifier   :string
#

class Category < ApplicationRecord
  belongs_to :parent, class_name: 'Category', optional: true
  has_many :children, class_name: 'Category', foreign_key: :parent_id, inverse_of: :parent, dependent: :destroy
  has_many :products, dependent: :destroy

  validates :name, presence: true
  validate :parent_relation

  scope :search_by_name, ->(name) { where('name ILIKE ?', "%#{name}%") }

  has_unique_identifier :g_identifier, segment_count: 3, segment_size: 2, delimiter: '-'

  def self.search_by(query:)
    search_by_name(query)
  end

  # TODO: Reduce Complexity / Split up.
  def self.batch_create(category_list)
    begin
    ActiveRecord::Base.transaction do
      category_list.each_with_index do |row, i|
        last_line = i + 2
        raise "Blank field on line #{last_line}" if row[:name].blank? || row[:parent].blank?

        parent = Category.find_by(name: row[:parent])
        raise "Unable to find parent category #{row[:parent]} on line #{last_line}" if parent.nil?

        c = Category.new(name: row[:name], parent: parent)
        raise "Line #{last_line} is invalid: #{c.errors.full_messages.join(',')}" if c.errors.any?

        c.save
      end
    end
    rescue RuntimeError => e
      return e.message
  end
    nil
  end

  def parent_relation
    return unless id.present? && parent_id == id

    errors.add(:parent_id, 'can\'t be equal to id')
  end
end
