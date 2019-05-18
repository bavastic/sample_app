class AddIndexForIdentifierInProducts < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_index :products, :p_identifier, unique: true, algorithm: :concurrently
  end
end
