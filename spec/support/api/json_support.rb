# frozen_string_literal: true
module ApiJsonSupport
  extend ActiveSupport::Concern

  def json
    MultiJson.load(response.body, symbolize_keys: true)
  end
end
