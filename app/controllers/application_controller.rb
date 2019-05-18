# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from Exception do
    render_error(
      message: "#{error_target}: unknown error!",
      status: :internal_server_error
    )
  end

  rescue_from ActiveRecord::RecordInvalid do
    render_error(
      message: "#{error_target}!",
      status: :not_acceptable
    )
  end

  rescue_from ActiveRecord::RecordNotFound do
    render_error(
      message: "#{error_target}: record not found!",
      status: :not_found
    )
  end

  private

  def hash_keys_to_snake_case(hash:)
    hash.each_with_object({}) do |(k, v), mem|
      mem[k.underscore.to_sym] = v
    end
  end

  def pagination_attr
    return {} unless params[:page] && params[:per_page]

    { current_page: params[:page], page_size: params[:per_page] }
  end

  def error_target
    I18n.t("errors.#{controller_name}.#{action_name}")
  end

  def render_error(message:, status:)
    render json: { notification: { level: 'error', message: message } }, status: status
  end
end
