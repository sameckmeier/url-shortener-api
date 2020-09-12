class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include Knock::Authenticable

  rescue_from StandardError, with: :render_internal_server_error
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_internal_server_error(err)
    logger.error(err.message)
    logger.error(err.backtrace[0])

    render json: { error: 'Opps! Looks like something went wrong' }, status: :internal_server_error
  end

  def render_not_found(_err)
    render json: { error: "Couldn't find record" }, status: :not_found
  end
end
