# frozen_string_literal: true

class CategoriesController < ApplicationController
  def count
    render json: { count: service.categories_count }
  end

  def index
    paginated_categories = service.fetch!(search: params[:query], sort: { id: :asc }, pagination: pagination_attr)

    render json: paginated_categories.collection
  end

  def show
    category = service.find!(category_id: params[:id])

    render json: category
  end

  def destroy
    category = service.destroy!(category_id: params[:id])

    render json: category
  end

  def update
    category = service.update!(category_id: params[:id], category_attr: category_attr)

    render json: category
  end

  def create
    category = service.create!(category_attr: category_attr)

    render json: category
  end

  def options
    paginated_categories = service.fetch!(sort: { name: :asc })

    render json: paginated_categories.collection, each_serializer: CategoryOptionSerializer
  end

  def upload
    error, sheet = helpers.validate_spreadsheet(params[:category_file].tempfile, %w(Name Parent), 'Categories')
    render(json: { message: error }) && return unless error.nil?

    batch_result = Category.batch_create(sheet.parse(name: 'Name', parent: 'Parent'))
    if batch_result.blank?
      render(json: { message: nil }) && return
    else
      render(json: { message: batch_result }) && return
    end
  end

  private

  def category_attr
    @category_attr ||= hash_keys_to_snake_case(hash: category_params.to_h)
  end

  def category_params
    params.require(:category).permit(:name, :parentId)
  end

  def service
    @service ||= CategoryService.new
  end
end
