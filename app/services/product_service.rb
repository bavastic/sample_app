# frozen_string_literal: true

class ProductService
  include Concerns::Paginateable
  include Concerns::Sortable

  CREATE_ATTR = %i(name category_id price currency display_currency)
  UPDATE_ATTR = %i(name category_id price currency display_currency)

  def fetch!(search: '', sort: {}, pagination: {})
    records = scoped_products.includes(:category).search_by(query: search)
    records = sort_relation(relation: records, sort: sort) if sort.present?

    paginate_relation(relation: records, **pagination.slice(:current_page, :page_size))
  end

  def find!(product_id:)
    product_by_id(id: product_id)
  end

  def create!(product_attr:)
    Product.create!(product_attr.slice(*CREATE_ATTR))
  end

  def update!(product_id:, product_attr: {})
    product = product_by_id(id: product_id)
    product.update!(product_attr.slice(*UPDATE_ATTR))

    product
  end

  def destroy!(product_id:)
    product_by_id(id: product_id).destroy!
  end

  def product_count
    scoped_products.count
  end

  protected

  def product_by_id(id:)
    scoped_products.find(id)
  end

  def scoped_products
    Product
  end
end
