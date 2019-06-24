# frozen_string_literal: true

class ProductsController < ApplicationController
  def count
    render json: { count: service.products_count }
  end

  def index
    paginated_products = service.fetch!(search: params[:query], sort: { id: :asc }, pagination: pagination_attr)

    render json: paginated_products.collection
  end

  def show
    product = service.find!(product_id: params[:id])

    render json: product
  end

  def destroy
    product = service.destroy!(product_id: params[:id])

    render json: product
  end

  def update
    product = service.update!(product_id: params[:id], product_attr: product_attr)

    render json: product
  end

  def create
    product = service.create!(product_attr: product_attr)

    render json: product
  end

  def upload
    error, sheet = helpers.validate_spreadsheet(params[:product_file].tempfile,
                                                %w(Name Category Price Currency DisplayCurrency), 'Products')
    render(json: { message: error }) && return unless error.nil?

    batch_result = Product.batch_create(sheet.parse(name: 'Name', category: 'Category',
                                                    price: 'Price', currency: 'Currency',
                                                    display_currency: 'DisplayCurrency'))
    render(json: { message: nil }) && return if batch_result.blank?
    render(json: { message: batch_result }) && return
  end

  def options
    paginated_products = service.fetch!(sort: { name: :asc })

    render json: paginated_products.collection, each_serializer: ProductOptionSerializer
  end

  private

  def product_attr
    @product_attr ||= hash_keys_to_snake_case(hash: product_params.to_h)
  end

  def product_params
    params.require(:product).permit(:categoryId, :name, :price, :currency, :displayCurrency)
  end

  def service
    @service ||= ProductService.new
  end
end
