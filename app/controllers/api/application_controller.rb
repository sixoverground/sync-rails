class Api::ApplicationController < ApplicationController
  protect_from_forgery with: :null_session

  skip_before_filter  :verify_authenticity_token

  before_filter :require_json

  private

  def require_json
    if (env['CONTENT_TYPE'].present? && !env['CONTENT_TYPE'].include?('application/json')) && ['POST', 'PATCH', 'DELETE'].include?(env['REQUEST_METHOD'])
      render json: { message: 'Body should be a JSON object' }, status: :bad_request
    end
  end
end
