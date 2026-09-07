module ApiKeyAuthenticable
  extend ActiveSupport::Concern

  attr_reader :current_api_key

  included do
    before_action :authenticate_with_api_key!
  end

  private

  def authenticate_with_api_key!
  end
end
