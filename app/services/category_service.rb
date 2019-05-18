# frozen_string_literal: true

class CategoryService
  include Concerns::Paginateable
  include Concerns::Sortable

  CREATE_ATTR = %i(name parent_id).freeze
  UPDATE_ATTR = %i(name parent_id).freeze

  def fetch!(search: '', sort: {}, pagination: {})
    records = scoped_categories.includes(:parent).search_by(query: search)
    records = sort_relation(relation: records, sort: sort) if sort.present?

    paginate_relation(relation: records, **pagination.slice(:current_page, :page_size))
  end

  def find!(category_id:)
    category_by_id(id: category_id)
  end

  def create!(category_attr:)
    Category.create!(category_attr.slice(*CREATE_ATTR))
  end

  def update!(category_id:, category_attr: {})
    category = category_by_id(id: category_id)
    category.update!(category_attr.slice(*UPDATE_ATTR))

    category
  end

  def destroy!(category_id:)
    category_by_id(id: category_id).destroy!
  end

  def categories_count
    scoped_categories.count
  end

  protected

  def category_by_id(id:)
    scoped_categories.find(id)
  end

  def scoped_categories
    Category
  end
end
