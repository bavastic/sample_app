# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

unless Rails.env.test?
  root = Category.create!(name: 'ROOT')
  Category.create!(name: Faker::Commerce.unique.department, parent: root)
  Category.create!(name: Faker::Commerce.unique.department, parent: root)
  Category.create!(name: Faker::Commerce.unique.department, parent: root)

  num_categories = Random.rand(5...10)

  Rails.logger.info "generating database seeds: #{num_categories} Category records"

  num_categories.times do
    category = Category.create(name: Faker::Commerce.unique.department, parent_id: Random.rand(1...3))
    num_products = Random.rand(10...15)

    Rails.logger.info "generating database seeds: #{num_products} " \
    "Product records for '#{category.name}' ##{category.id} Category record"

    num_products.times do
      Product.create(
        category: category,
        name: Faker::Commerce.unique.product_name,
        price: Faker::Commerce.price,
        display_currency: Random.rand(0...2).positive? ? 'EUR' : 'USD'
      )
    end
  end
end
