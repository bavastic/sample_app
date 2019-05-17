# frozen_string_literal: true

class CategoriesController < ApplicationController
  include Swagger::Blocks

  # GET /categories/count

  swagger_path '/categories/count' do
    operation :get do
      key :summary, 'Total number of all categories'
      key :description, 'Returns count for all categories'
      key :operationId, 'countCategories'

      key :tags, [
        'category'
      ]

      response 200 do
        key :description, 'counter response'

        schema do
          key :'$ref', :CategoryCount
        end
      end

      response :default do
        key :description, 'unknown error'
      end
    end
  end

  def count
    render json: { count: service.category_count }
  rescue Exception
    render json: { notification: { level: 'error', message: 'Cannot count categories: unknown error!' } }, status: :internal_server_error
  end

  # GET /categories

  swagger_path '/categories' do
    operation :get do
      key :summary, 'Fetch all categories'
      key :description, 'Returns all categories, includes support for pagination and basic fulltext search'
      key :operationId, 'findCategories'

      key :tags, [
        'category'
      ]

      parameter do
        key :name, :query
        key :in, :query
        key :description, 'search term to filter results by'
        key :required, false
        key :type, :string
      end

      parameter do
        key :name, :per_page
        key :in, :query
        key :description, 'maximum number of results to return, used for pagination'
        key :required, false
        key :type, :integer
      end

      parameter do
        key :name, :page
        key :in, :query
        key :description, 'selected results page, used for pagination'
        key :required, false
        key :type, :integer
      end

      response 200 do
        key :description, 'category response'

        schema do
          key :type, :array

          items do
            key :'$ref', :CategoryJSON
          end
        end
      end

      response :default do
        key :description, 'unknown error'
      end
    end
  end

  def index
    paginated_categories = service.fetch!(search: params[:query], sort: { id: :asc }, pagination: pagination_attr)
    render json: paginated_categories.collection.as_json
  rescue Exception
    render json: { notification: { level: 'error', message: 'Cannot list categories: unknown error!' } }, status: :internal_server_error
  end

  # GET /categories/:id

  swagger_path '/categories/{id}' do
    operation :get do
      key :summary, 'Find category by ID'
      key :description, 'Returns a single category'
      key :operationId, 'findCategoryById'

      key :tags, [
        'category'
      ]

      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of category to fetch'
        key :required, true
        key :type, :integer
      end

      response 200 do
        key :description, 'category response'

        schema do
          key :'$ref', :CategoryJSON
        end
      end

      response :not_found do
        key :description, 'no record found for submitted ID'
      end

      response :default do
        key :description, 'unknown error'
      end
    end
  end

  def show
    category = service.find!(category_id: params[:id])

    render json: category.as_json
  rescue ActiveRecord::RecordNotFound
    render json: { notification: { level: 'error', message: 'Cannot show category: record not found!' } }, status: :not_found
  rescue Exception
    render json: { notification: { level: 'error', message: 'Cannot show category: unknown error!' } }, status: :internal_server_error
  end

  # DELETE /categories/:id

  swagger_path '/categories/{id}' do
    operation :delete do
      key :summary, 'Delete category by ID'
      key :description, 'Removes a single category from database'
      key :operationId, 'removeCategoryById'

      key :tags, [
        'category'
      ]

      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of category to delete'
        key :required, true
        key :type, :integer
      end

      response 200 do
        key :description, 'category response (returns the record that has been destroyed)'

        schema do
          key :'$ref', :CategoryJSON
        end
      end

      response :not_found do
        key :description, 'no record found for submitted ID'
      end

      response :default do
        key :description, 'unknown error'
      end
    end
  end

  def destroy
    category = service.destroy!(category_id: params[:id])

    render json: category.as_json
  rescue ActiveRecord::RecordNotFound
    render json: { notification: { level: 'error', message: 'Cannot destroy category: record not found!' } }, status: :not_found
  rescue Exception
    render json: { notification: { level: 'error', message: 'Cannot destroy category: unknown error!' } }, status: :internal_server_error
  end

  # PUT /categories/:id

  swagger_path '/categories/{id}' do
    operation :put do
      key :summary, 'Modify existing category'
      key :description, 'Updates an existing category and stores the record in the database after model validation'
      key :operationId, 'updateCategory'

      key :tags, [
        'category'
      ]

      parameter do
        key :name, :category
        key :in, :body
        key :description, 'Category data to update'
        key :required, true

        schema do
          key :'$ref', :CategoryUpdate
        end
      end

      response 200 do
        key :description, 'category response'

        schema do
          key :'$ref', :CategoryJSON
        end
      end

      response :not_found do
        key :description, 'no record found for submitted ID'
      end

      response :default do
        key :description, 'unknown error'
      end
    end
  end

  def update
    category = service.update!(category_id: params[:id], category_attr: category_attr)

    render json: category.as_json
  rescue ActiveRecord::RecordInvalid
    render json: { notification: { level: 'error', message: 'Cannot update category!' } }, status: :not_acceptable
  rescue ActiveRecord::RecordNotFound
    render json: { notification: { level: 'error', message: 'Cannot delete category: record not found!' } }, status: :not_found
  rescue Exception
    render json: { notification: { level: 'error', message: 'Cannot delete category: unknown error!' } }, status: :internal_server_error
  end

  # POST /categories

  swagger_path '/categories' do
    operation :post do
      key :summary, 'Add new category'
      key :description, 'Creates a new category and stores the record in the database after model validation'
      key :operationId, 'addCategory'

      key :tags, [
        'category'
      ]

      parameter do
        key :name, :category
        key :in, :body
        key :description, 'Category to add'
        key :required, true

        schema do
          key :'$ref', :CategoryCreate
        end
      end

      response 200 do
        key :description, 'category response'

        schema do
          key :'$ref', :CategoryJSON
        end
      end

      response :not_acceptable do
        key :description, 'model validation failed'
      end

      response :default do
        key :description, 'unknown error'
      end
    end
  end

  def create
    category = service.create!(category_attr: category_attr)

    render json: category.as_json
  rescue ActiveRecord::RecordInvalid
    render json: { notification: { level: 'error', message: 'Cannot create category!' } }, status: :not_acceptable
  rescue Exception
    render json: { notification: { level: 'error', message: 'Cannot delete category: unknown error!' } }, status: :internal_server_error
  end

  # GET /categories/options

  swagger_path '/categories/options' do
    operation :get do
      key :summary, 'Fetch all categories'
      key :description, 'Returns list of all categories for use with HTML select form field'
      key :operationId, 'categoriesAsSelectOptions'

      key :tags, [
        'category'
      ]

      response 200 do
        key :description, 'category response'

        schema do
          key :type, :array

          items do
            key :'$ref', :CategoryOption
          end
        end
      end

      response :default do
        key :description, 'unknown error'
      end
    end
  end

  def options
    paginated_categories = service.fetch!(sort: { name: :asc })
    render json: paginated_categories.collection.as_json(only: [], methods: %i(value text))
  rescue Exception
    render json: { notification: { level: 'error', message: 'Cannot fetch categories: unknown error!' } }, status: :internal_server_error
  end

  private

  def category_attr
    @category_attr ||= hash_keys_to_snake_case(hash: category_params.to_h)
  end

  def pagination_attr
    return {} unless params[:page] && params[:per_page]
    { current_page: params[:page], page_size: params[:per_page] }
  end

  def category_params
    @category_params ||= params.require(:category).permit(:name, :parentId)
  end

  def service
    @sevice ||= CategoryService.new
  end
end
