module ExceptionHandler
  extend ActiveSupport::Concern
  class ExpiredSignature < StandardError; end
  class InvalidAuthenticityToken < StandardError; end
  included do
    rescue_from ExceptionHandler::ExpiredSignature do |_error|
      render json: {
        message: "Access denied!. Token has expired."
      }, status: :ok
    end
  end
end