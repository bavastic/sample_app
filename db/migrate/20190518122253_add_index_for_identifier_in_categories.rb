# frozen_string_literal: true

class AddIndexForIdentifierInCategories < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_index :categories, :g_identifier, unique: true, algorithm: :concurrently
  end
end
