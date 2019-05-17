# frozen_string_literal: true

module Concerns
  module Paginateable
    extend ActiveSupport::Concern

    included do
      def paginate_relation(relation:, current_page: nil, page_size: nil)
        return Helpers::Pagination::ResponseValueObject.new(collection: relation) if page_size.nil?

        paginate_with_kaminari(
          relation: relation,
          current_page: (current_page || 1).to_i,
          page_size: page_size.to_i
        )
      end

      private

      def paginate_with_kaminari(relation:, current_page:, page_size:)
        collection = relation.page(current_page).per(page_size)

        Helpers::Pagination::ResponseValueObject.new(
          collection: collection,
          total_count: collection.total_count,
          limit_value: collection.limit_value,
          total_pages: collection.total_pages,
          current_page: collection.current_page
        )
      end
    end
  end
end
