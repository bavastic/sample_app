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

  def parent_relation
    return unless id.present? && parent_id == id

    errors.add(:parent_id, 'can\'t be equal to id')
  end
end
