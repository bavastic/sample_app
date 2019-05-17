module ApiSwagger
  class CategorySchema
    include Swagger::Blocks

    swagger_schema :CategoryJSON do
      key :required, [:id]

      property :id do
        key :type, :integer
      end

      property :name do
        key :type, :string
      end

      property :displayName do
        key :type, :string
        key :description, 'virtual field, name for displaying a record in the UI'
      end

      property :parentId do
        key :type, :integer
        key :description, 'self reference to ID of parent category'
      end

      property :parentName do
        key :type, :string
        key :description, 'virtual field, references name of parent category'
      end

      property :productsCount do
        key :type, :integer
        key :description, 'counter cache for product records'
      end
    end

    swagger_schema :CategoryOption do
      property :value do
        key :type, :integer
        key :description, 'references ID field'
      end

      property :text do
        key :type, :string
        key :description, 'references name field'
      end
    end

    swagger_schema :CategoryCount do
      property :count do
        key :type, :integer
      end
    end

    swagger_schema :CategoryCreate do
      property :name do
        key :type, :string
      end

      property :parentId do
        key :type, :integer
      end
    end

    swagger_schema :CategoryUpdate do
      property :id do
        key :type, :integer
      end

      property :name do
        key :type, :string
      end

      property :parentId do
        key :type, :integer
      end
    end
  end
end
