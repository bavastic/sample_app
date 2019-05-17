# frozen_string_literal: true

class ApidocsController < ActionController::Base
  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'

    info do
      key :version, '1.0.0'
      key :title, 'Swagger Shoppu (Ruby on Rails)'
      key :description, 'A sample API documentation'
    end

    tag do
      key :name, 'category'
      key :description, 'Category operations'

      externalDocs do
        key :description, 'Find more info here'
        key :url, 'https://swagger.io'
      end
    end

    key :host, 'shoppu-frontend.herokuapp.com'
    key :schemes, %w(http https)
    key :basePath, '/api'
    key :consumes, ['application/json']
    key :produces, ['application/json']
  end

  SWAGGERED_CLASSES = [
    CategoriesController,
    Category,
    self
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
