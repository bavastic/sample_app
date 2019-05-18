# frozen_string_literal: true

require 'active_record'
require 'active_support/core_ext/module'

# Create a character token value for an ActiveRecord object that is
# unique within the scope of the object's class
module HasUniqueIdentifier
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Naming/PredicateName, Metrics/LineLength
  def has_unique_identifier(attribute_name, segment_count:, segment_size:, delimiter:)
    class_eval do
      before_create "set_#{attribute_name}_token".to_sym
    end

    define_method "set_#{attribute_name}_token" do
      send("#{attribute_name}=", send("generate_#{attribute_name}_token"))
    end

    define_method "generate_#{attribute_name}_token" do
      loop do
        token = Array.new(segment_count) do
          Array.new(segment_size) { ('A'..'Z').to_a.sample }.join
        end.join(delimiter)
        break token unless self.class.where(attribute_name => token).exists?
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Naming/PredicateName, Metrics/LineLength
end

ActiveSupport.on_load(:active_record) do
  extend HasUniqueIdentifier
end
