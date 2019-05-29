# frozen_string_literal: true

class ProductOptionSerializer < ActiveModel::Serializer
  include Swagger::Blocks

  attribute :id, key: :value
  attribute :name, key: :text
end
