# frozen_string_literal: true

class ApplicationController < ActionController::API
  include GraphqlDevise::SetUserByToken

  unless Rails.env.test?
    rescue_from Exception, with: :exception_note
  end

  IGNORE_EXCEPTIONS = [
    AbstractController::ActionNotFound,
    ActionController::RoutingError,
    ActionController::UnknownHttpMethod
  ]

  private

  # Send exception to Altitude.
  #
  # Just re-raise exceptions included in IGNORE_EXCEPTIONS if in production.
  #
  # @param exception [Exception]
  def exception_note exception
    if IGNORE_EXCEPTIONS.include?(exception.class) && !Rails.env.development?
      raise
    else
      PtiIssues.handle_exception exception: exception, request: request
    end
  end
end
