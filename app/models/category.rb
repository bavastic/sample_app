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

  validates :name, presence: true, uniqueness: true
  validate :parent_relation

  scope :search_by_name, ->(name) { where('name ILIKE ?', "%#{name}%") }

  has_unique_identifier :g_identifier, segment_count: 3, segment_size: 2, delimiter: '-'

  def self.search_by(query:)
    search_by_name(query)
  end

  def self.batch_create(category_list)
    begin
      ActiveRecord::Base.transaction do
        category_list.each_with_index { |row, i| create_from_row(row, i + 2) }
      end
    rescue RuntimeError => e
      return e.message
    end
    nil
  end

  def self.create_from_row(row, number)
    raise "Blank field on row #{number}" if row.values.any?(&:blank?)

    category = create_from_hash(row, number)
    category.save
  end

  def self.create_from_hash(hash, line)
    parent = Category.find_by(name: hash[:parent])
    raise "Unable to find parent category #{hash[:parent]} on row #{line}" if parent.nil?

    category = Category.new(name: hash[:name], parent: parent)
    raise "Invalid Data: #{c.errors.full_messages.join(',')} on row #{line}" if category.errors.any?

    category
  end

  def parent_relation
    return unless id.present? && parent_id == id

    errors.add(:parent_id, 'can\'t be equal to id')
  end
end
