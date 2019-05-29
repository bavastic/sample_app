# frozen_string_literal: true

module ApiSwagger
  # rubocop:disable Metrics/BlockLength
  # rubocop:disable Metrics/ClassLength
  class CategoriesController
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

    # GET /categories
    swagger_path '/categories' do
      operation :get do
        key :summary, 'Fetch all categories'
        key :description, 'Returns all categories, includes support for pagination and basic substring search'
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
  end
  # rubocop:enable Metrics/ClassLength
  # rubocop:enable Metrics/BlockLength
end
