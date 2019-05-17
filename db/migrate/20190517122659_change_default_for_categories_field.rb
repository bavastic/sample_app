class ChangeDefaultForCategoriesField < ActiveRecord::Migration[5.2]
  def change
    change_column_default :categories, :products_count, 0
  end
end
