class ChangeProductsName < ActiveRecord::Migration[5.2]
  def change
    change_column_null :products, :name, false
  end
end
