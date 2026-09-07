# frozen_string_literal: true

module ApiKeyAuthenticable
  extend ActiveSupport::Concern

  attr_reader :current_api_key

  included do
    before_action :authenticate_with_api_key!
  end

  private

  def authenticate_with_api_key!
    @current_api_key = ApiKey.find_by token: ApiKey.digest(fetch_api_key!)
    raise Pundit::NotAuthorizedError.new('No corresponding key found') unless @current_api_key
  end

  def fetch_api_key!
    api_key = request.headers['X-Api-Key'] || params[:api_key]
    raise Pundit::NotAuthorizedError.new('No API key') unless api_key

    api_key
  end
end
