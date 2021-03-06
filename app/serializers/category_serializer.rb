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

class CategorySerializer < ActiveModel::Serializer
  include Swagger::Blocks

  attributes :id, :name
  attribute :parent_id, key: :parentId
  attribute :parent_name, key: :parentName
  attribute :products_count, key: :productsCount
  attribute :display_name, key: :displayName
  attribute :g_identifier, key: :identifier

  def display_name
    return object.name if object.parent.blank?

    "#{object.parent.name} > #{object.name}"
  end

  def parent_name
    object.parent&.name
  end
end
