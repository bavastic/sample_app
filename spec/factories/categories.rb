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

FactoryBot.define do
  sequence(:category_name) { |n| "#{Faker::Lorem.word}_#{n}" }

  factory :category do
    name { generate(:category_name) }
  end
end
