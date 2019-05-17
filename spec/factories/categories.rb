# == Schema Information
#
# Table name: categories
#
#  id             :bigint           not null, primary key
#  parent_id      :bigint
#  name           :string           not null
#  products_count :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryBot.define do
  sequence(:category_name) { |n| "#{Faker::Lorem.word}_#{n}" }

  factory :category do
    name { generate(:category_name) }
  end
end
