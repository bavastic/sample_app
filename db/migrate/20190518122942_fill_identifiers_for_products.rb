# frozen_string_literal: true

class FillIdentifiersForProducts < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    Product.reset_column_information

    Product.find_each do |record|
      next if record.p_identifier.present?

      record.set_p_identifier_token
      record.save!
    end
  end

  def down; end
end
