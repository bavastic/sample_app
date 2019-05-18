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

class ProductSerializer < ActiveModel::Serializer
  include Swagger::Blocks

  attributes :id, :name, :currency, :price
  attribute :display_name, key: :displayName
  attribute :category_id, key: :categoryId
  attribute :category_name, key: :categoryName
  attribute :display_currency, key: :displayCurrency

  def display_name
    object.name
  end

  def category_name
    object.category.name
  end
end
