# frozen_string_literal: true

class ChangeCategoriesName < ActiveRecord::Migration[5.2]
  def change
    change_column_null :categories, :name, false
  end
end
