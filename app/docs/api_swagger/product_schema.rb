# frozen_string_literal: true

module ApiSwagger
  # rubocop:disable Metrics/BlockLength
  class ProductSchema
    include Swagger::Blocks

    swagger_schema :ProductJSON do
      key :required, [:id]

      property :id do
        key :type, :integer
      end

      property :name do
        key :type, :string
      end

      property :currency do
        key :type, :string
      end

      property :displayCurrency do
        key :type, :integer
      end

      property :price do
        key :type, :number
      end

      property :displayName do
        key :type, :string
        key :description, 'virtual field, name for displaying a record in the UI'
      end

      property :categoryId do
        key :type, :integer
        key :description, 'self reference to ID of category'
      end

      property :categoryName do
        key :type, :string
        key :description, 'name of category of product'
      end

      property :identifier do
        key :type, :string
        key :description, 'identifier of the product'
      end
    end

    swagger_schema :ProductOption do
      property :value do
        key :type, :integer
        key :description, 'references ID field'
      end

      property :text do
        key :type, :string
        key :description, 'references name field'
      end
    end

    swagger_schema :ProductCount do
      property :count do
        key :type, :integer
      end
    end

    swagger_schema :ProductCreate do
      property :name do
        key :type, :string
      end

      property :categoryId do
        key :type, :integer
      end

      property :price do
        key :type, :number
        key :format, :double
      end

      property :currency do
        key :type, :string
      end

      property :displayCurrency do
        key :type, :string
      end
    end

    swagger_schema :ProductUpdate do
      property :id do
        key :type, :integer
      end

      property :name do
        key :type, :string
      end

      property :categoryId do
        key :type, :integer
      end

      property :price do
        key :type, :number
        key :format, :double
      end

      property :currency do
        key :type, :string
      end

      property :displayCurrency do
        key :type, :string
      end
    end
  end
  # rubocop:enable Metrics/BlockLength
end
