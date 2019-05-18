class FillIdentifiersForCategories < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    Category.reset_column_information

    Category.find_each do |record|
      next if record.g_identifier.present?

      record.set_g_identifier_token
      record.save!
    end
  end

  def down;end
end
