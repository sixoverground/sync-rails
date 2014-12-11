class ErrorsController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def not_found
    if json_request?
      render json: { message: "We couldn't find that! Please try again." }.to_json, status: :not_found
    else
      render layout: 'errors', status: :not_found
    end
  end

  def unacceptable
    if json_request?
      render json: { message: "We weren't expecting that! Please try again." }.to_json, status: :not_found
    else
      render layout: 'errors', status: :unacceptable
    end
  end

  def internal_server_error
    if json_request?
      render json: { message: 'Something went wrong! Please try again.' }.to_json, status: :internal_server_error
    else
      render layout: 'errors', status: :internal_server_error
    end
  end

  private

  def json_request?
    env['CONTENT_TYPE'] == 'application/json' || /application\/.*json/.match(request.format) || env['REQUEST_PATH'] =~ /^\/api/
  end
end
