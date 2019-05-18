# frozen_string_literal: true

class ChangeDefaultForCategoriesField < ActiveRecord::Migration[5.2]
  def up
    change_column_default :categories, :products_count, 0
  end

  def down
    change_column_default :categories, :products_count, nil
  end
end
