# frozen_string_literal: true

class RequestGeocodeService
  def initialize(model, api_provider = ApiProviders::IpStack)
    @api_provider = api_provider.new(Rails.configuration.x.api_provider)
    @model = model
  end

  def call
    @api_provider.fetch_results(@model.target, @model.host)
  end
end
