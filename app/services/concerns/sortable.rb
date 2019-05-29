# frozen_string_literal: true

module Concerns
  module Sortable
    extend ActiveSupport::Concern

    included do
      def sort_relation(relation:, sort:)
        relation.order(sort)
      end
    end
  end
end
