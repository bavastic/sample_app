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

  def self.batch_create(product_list)
    begin
      ActiveRecord::Base.transaction do
        product_list.each_with_index { |row, i| create_from_row(row, i + 2) }
      end
    rescue RuntimeError => e
      return e.message
    end
    nil
  end

  def self.create_from_row(row, number)
    raise "Blank field on row #{number}" if row.values.any?(&:blank?)

    product = create_from_hash(row, number)
    product.save
  end

  def self.create_from_hash(hash, line)
    category = Category.find_by(name: hash[:category])
    raise "Unable to find category #{hash[:category]} on row #{line}" if category.nil?

    hash[:category] = category # Found category? Put it in the hash.

    product = Product.new(hash)
    raise "Invalid Data: #{product.errors.full_messages.join(',')} on row #{line}" if product.errors.any?

    product
  end

  private

  def default_values
    self.price ||= 0
  end
end
