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

class ProductSerializer < ActiveModel::Serializer
  include Swagger::Blocks

  attributes :id, :name, :currency, :price
  attribute :display_name, key: :displayName
  attribute :category_id, key: :categoryId
  attribute :category_name, key: :categoryName
  attribute :display_currency, key: :displayCurrency
  attribute :p_identifier, key: :identifier

  def display_name
    object.name
  end

  def category_name
    object.category.name
  end
end
