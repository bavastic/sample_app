# frozen_string_literal: true

class AddGIdentifierToCategories < ActiveRecord::Migration[5.2]
  def up
    add_column :categories, :g_identifier, :string
  end

  def down
    remove_column :categories, :g_identifier
  end
end
