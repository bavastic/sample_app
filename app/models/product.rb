# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id               :uuid             not null, primary key
#  category_id      :uuid
#  name             :string           not null
#  price            :decimal(, )
#  currency         :string           default("EUR")
#  display_currency :string           default("EUR")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  p_identifier     :string
#

class Product < ApplicationRecord
  belongs_to :category, counter_cache: true

  validates :name, presence: true

  before_save :default_values

  has_unique_identifier :p_identifier, segment_count: 2, segment_size: 3, delimiter: '/'

  scope :search_by_name, ->(name) { where('name ILIKE ?', "%#{name}%") }

  def self.search_by(query:)
    search_by_name(query)
  end

  private

  def default_values
    self.price ||= 0
  end
end
