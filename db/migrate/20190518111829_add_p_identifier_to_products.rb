# frozen_string_literal: true

class AddPIdentifierToProducts < ActiveRecord::Migration[5.2]
  def up
    add_column :products, :p_identifier, :string
  end

  def down
    remove_column :products, :p_identifier
  end
end
