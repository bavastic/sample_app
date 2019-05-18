
class AddForeignKeyForParentCategories < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :categories, :categories, column: :parent_id
  end
end
