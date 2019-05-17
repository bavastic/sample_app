# frozen_string_literal: true

class ProductsController < ApplicationController
  # GET /products/count
  def count
    render json: { count: service.product_count }
  rescue Exception
    render json: { notification: { level: 'error', message: 'Cannot count @products: unknown error!' } }, status: :internal_server_error
  end

  # GET /products
  def index
    paginated_products = service.fetch!(search: params[:query], sort: { id: :asc }, pagination: pagination_attr)
    render json: paginated_products.collection.as_json
  rescue Exception
    render json: { notification: { level: 'error', message: 'Cannot list products: unknown error!' } }, status: :internal_server_error
  end

  # GET /products/:id
  def show
    product = service.find!(product_id: params[:id])

    render json: product.as_json
  rescue ActiveRecord::RecordNotFound
    render json: { notification: { level: 'error', message: 'Cannot show product: record not found!' } }, status: :not_found
  rescue Exception
    render json: { notification: { level: 'error', message: 'Cannot show product: unknown error!' } }, status: :internal_server_error
  end

  # DELETE /products/:id
  def destroy
    product = service.destroy!(product_id: params[:id])

    render json: product.as_json
  rescue ActiveRecord::RecordNotFound
    render json: { notification: { level: 'error', message: 'Cannot destroy product: record not found!' } }, status: :not_found
  rescue Exception
    render json: { notification: { level: 'error', message: 'Cannot destroy product: unknown error!' } }, status: :internal_server_error
  end

  # PUT /products/:id
  def update
    product = service.update!(product_id: params[:id], product_attr: product_attr)

    render json: product.as_json
  rescue ActiveRecord::RecordInvalid
    render json: { notification: { level: 'error', message: 'Cannot update product!' } }, status: :not_acceptable
  rescue ActiveRecord::RecordNotFound
    render json: { notification: { level: 'error', message: 'Cannot delete product: record not found!' } }, status: :not_found
  rescue Exception
    render json: { notification: { level: 'error', message: 'Cannot delete product: unknown error!' } }, status: :internal_server_error
  end

  # POST /products
  def create
    product = service.create!(product_attr: product_attr)

    render json: product.as_json
  rescue ActiveRecord::RecordInvalid
    render json: { notification: { level: 'error', message: 'Cannot create product!' } }, status: :not_acceptable
  rescue Exception
    render json: { notification: { level: 'error', message: 'Cannot delete product: unknown error!' } }, status: :internal_server_error
  end

  # GET /products/options
  def options
    paginated_products = service.fetch!(sort: { name: :asc })
    render json: paginated_products.collection.as_json(only: [], methods: %i(value text))
  rescue Exception
    render json: { notification: { level: 'error', message: 'Cannot fetch products: unknown error!' } }, status: :internal_server_error
  end

  private

  def product_attr
    @product_attr ||= @category_attr ||= hash_keys_to_snake_case(hash: product_params.to_h)
  end

  def pagination_attr
    return {} unless params[:page] && params[:per_page]
    { current_page: params[:page], page_size: params[:per_page] }
  end

  def product_params
    params.require(:product).permit(:categoryId, :name, :price, :currency, :displayCurrency)
  end

  def service
    @sevice ||= ProductService.new
  end
end
