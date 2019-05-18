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

FactoryBot.define do
  sequence(:product_name) { |n| "#{Faker::Lorem.word}_#{n}" }

  factory :product do
    name { generate(:product_name) }
    price { Faker::Number.decimal(2, 2) }
    category { create(:category) }

    after(:build) do |product|
      currency_code = Faker::Currency.code
      product.currency ||= currency_code
      product.display_currency ||= currency_code
    end
  end
end
