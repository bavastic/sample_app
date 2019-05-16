# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.references :category, foreign_key: true

      t.string :name
      t.decimal :price
      t.string :currency, default: 'EUR'
      t.string :display_currency, default: 'EUR'

      t.timestamps
    end
  end
end
