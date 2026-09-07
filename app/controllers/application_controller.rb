class ApplicationController < ActionController::API
  include Graphiti::Rails::Controller
  include ApiKeyAuthenticable
end
