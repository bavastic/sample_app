# frozen_string_literal: true

module ApiSwagger
  # rubocop:disable Metrics/BlockLength
  # rubocop:disable Metrics/ClassLength
  class ProductsController
    include Swagger::Blocks

    # GET /products/count
    swagger_path '/products/count' do
      operation :get do
        key :summary, 'Total number of all products'
        key :description, 'Returns count for all products'
        key :operationId, 'countProducts'

        key :tags, [
          'product'
        ]

        response 200 do
          key :description, 'counter response'

          schema do
            key :'$ref', :ProductCount
          end
        end

        response :default do
          key :description, 'unknown error'
        end
      end
    end

    # GET /products
    swagger_path '/products' do
      operation :get do
        key :summary, 'Fetch all products'
        key :description, 'Returns all products, includes support for pagination and basic substring search'
        key :operationId, 'findProducts'

        key :tags, [
          'product'
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
          key :description, 'product response'

          schema do
            key :type, :array

            items do
              key :'$ref', :ProductJSON
            end
          end
        end

        response :default do
          key :description, 'unknown error'
        end
      end
    end

    # GET /products/:id
    swagger_path '/products/{id}' do
      operation :get do
        key :summary, 'Find product by ID'
        key :description, 'Returns a single product'
        key :operationId, 'findProductById'

        key :tags, [
          'product'
        ]

        parameter do
          key :name, :id
          key :in, :path
          key :description, 'ID of product to fetch'
          key :required, true
          key :type, :integer
        end

        response 200 do
          key :description, 'product response'

          schema do
            key :'$ref', :ProductJSON
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

    # DELETE /products/:id
    swagger_path '/products/{id}' do
      operation :delete do
        key :summary, 'Delete product by ID'
        key :description, 'Removes a single product from database'
        key :operationId, 'removeProductById'

        key :tags, [
          'product'
        ]

        parameter do
          key :name, :id
          key :in, :path
          key :description, 'ID of product to delete'
          key :required, true
          key :type, :integer
        end

        response 200 do
          key :description, 'product response (returns the record that has been destroyed)'

          schema do
            key :'$ref', :ProductJSON
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

    # PUT /products/:id
    swagger_path '/products/{id}' do
      operation :put do
        key :summary, 'Modify existing product'
        key :description, 'Updates an existing product and stores the record in the database after model validation'
        key :operationId, 'updateProduct'

        key :tags, [
          'product'
        ]

        parameter do
          key :name, :product
          key :in, :body
          key :description, 'Product data to update'
          key :required, true

          schema do
            key :'$ref', :ProductUpdate
          end
        end

        response 200 do
          key :description, 'product response'

          schema do
            key :'$ref', :ProductJSON
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

    # POST /products
    swagger_path '/products' do
      operation :post do
        key :summary, 'Add new product'
        key :description, 'Creates a new product and stores the record in the database after model validation'
        key :operationId, 'addProduct'

        key :tags, [
          'product'
        ]

        parameter do
          key :name, :product
          key :in, :body
          key :description, 'Product to add'
          key :required, true

          schema do
            key :'$ref', :ProductCreate
          end
        end

        response 200 do
          key :description, 'product response'

          schema do
            key :'$ref', :ProductJSON
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

    # GET /products/options
    swagger_path '/products/options' do
      operation :get do
        key :summary, 'Fetch all products'
        key :description, 'Returns list of all products for use with HTML select form field'
        key :operationId, 'productsAsSelectOptions'

        key :tags, [
          'product'
        ]

        response 200 do
          key :description, 'product response'

          schema do
            key :type, :array

            items do
              key :'$ref', :ProductOption
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
