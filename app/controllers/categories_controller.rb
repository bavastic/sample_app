# frozen_string_literal: true

class CategoriesController < ApplicationController
  def count
    render json: { count: service.categories_count }
  rescue Exception
    render json: { notification: { level: 'error', message: 'Cannot count categories: unknown error!' } }, status: :internal_server_error
  end

  def index
    paginated_categories = service.fetch!(search: params[:query], sort: { id: :asc }, pagination: pagination_attr)
    render json: paginated_categories.collection
  rescue Exception
    render json: { notification: { level: 'error', message: 'Cannot list categories: unknown error!' } }, status: :internal_server_error
  end

  def show
    category = service.find!(category_id: params[:id])

    render json: category
  rescue ActiveRecord::RecordNotFound
    render json: { notification: { level: 'error', message: 'Cannot show category: record not found!' } }, status: :not_found
  rescue Exception
    render json: { notification: { level: 'error', message: 'Cannot show category: unknown error!' } }, status: :internal_server_error
  end

  def destroy
    category = service.destroy!(category_id: params[:id])

    render json: category
  rescue ActiveRecord::RecordNotFound
    render json: { notification: { level: 'error', message: 'Cannot destroy category: record not found!' } }, status: :not_found
  rescue Exception
    render json: { notification: { level: 'error', message: 'Cannot destroy category: unknown error!' } }, status: :internal_server_error
  end

  def update
    category = service.update!(category_id: params[:id], category_attr: category_attr)

    render json: category
  rescue ActiveRecord::RecordInvalid
    render json: { notification: { level: 'error', message: 'Cannot update category!' } }, status: :not_acceptable
  rescue ActiveRecord::RecordNotFound
    render json: { notification: { level: 'error', message: 'Cannot delete category: record not found!' } }, status: :not_found
  rescue Exception
    render json: { notification: { level: 'error', message: 'Cannot delete category: unknown error!' } }, status: :internal_server_error
  end

  def create
    category = service.create!(category_attr: category_attr)

    render json: category
  rescue ActiveRecord::RecordInvalid
    render json: { notification: { level: 'error', message: 'Cannot create category!' } }, status: :not_acceptable
  rescue Exception
    render json: { notification: { level: 'error', message: 'Cannot delete category: unknown error!' } }, status: :internal_server_error
  end

  def options
    paginated_categories = service.fetch!(sort: { name: :asc })

    render json: paginated_categories.collection, each_serializer: CategoryOptionSerializer
  rescue Exception
    render json: { notification: { level: 'error', message: 'Cannot fetch categories: unknown error!' } }, status: :internal_server_error
  end

  private

  def category_attr
    @category_attr ||= hash_keys_to_snake_case(hash: category_params.to_h)
  end

  def category_params
    @category_params ||= params.require(:category).permit(:name, :parentId)
  end

  def service
    @sevice ||= CategoryService.new
  end
end
