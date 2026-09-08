# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Graphiti::Rails::Controller
  include Pundit::Authorization
  include ApiKeyAuthenticable

  register_exception Pundit::NotAuthorizedError,
    status: 401,
    message: ->(error) { error.message },
    detail: ->(error) { "Invalid Attempt" }

  register_exception ActiveRecord::RecordNotUnique,
    status: 422,
    message: ->(error) { error.message },
    detail: ->(error) { "Invalid Record" }

  register_exception Graphiti::Errors::RecordNotFound,
    status: 404,
    message: ->(error) { error.message },
    detail: ->(error) { "No Record" }

  def pundit_user
    current_api_key
  end

  def show_detailed_exceptions?
    false
  end
end
