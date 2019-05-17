# frozen_string_literal: true

module Helpers
  module Pagination
    class ResponseValueObject
      attr_accessor :collection,
                    :total_count,
                    :limit_value,
                    :total_pages,
                    :current_page

      def initialize(collection:, total_count: nil, limit_value: nil, total_pages: 1, current_page: 1)
        @collection = collection
        @total_count = total_count || collection.size
        @limit_value = limit_value
        @total_pages = total_pages
        @current_page = current_page
      end
    end
  end
end
