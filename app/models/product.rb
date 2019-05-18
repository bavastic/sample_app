# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id               :bigint           not null, primary key
#  category_id      :bigint
#  name             :string           not null
#  price            :decimal(, )
#  currency         :string           default("EUR")
#  display_currency :string           default("EUR")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Product < ApplicationRecord
  belongs_to :category, counter_cache: true

  validates :name, presence: true

  before_save :default_values

  scope :search_by_name, ->(name) { where('name ILIKE ?', "%#{name}%") }

  def self.search_by(query:)
    search_by_name(query)
  end

  private

  def default_values
    self.price ||= 0
  end
end
