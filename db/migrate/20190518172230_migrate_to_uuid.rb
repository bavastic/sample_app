# frozen_string_literal: true
require 'webdack/uuid_migration/helpers'

class MigrateToUuid < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        safety_assured do
          enable_extension 'pgcrypto'

          primary_key_and_all_references_to_uuid :categories
          primary_key_and_all_references_to_uuid :products
        end
      end

      dir.down do
        raise ActiveRecord::IrreversibleMigration
      end
    end
  end
end
