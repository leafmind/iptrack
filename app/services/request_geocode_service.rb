# frozen_string_literal: true

class RequestGeocodeService
  PROVIDER_URI = "https://api.ipstack.com"
  ACCESS_KEY = "7d093c3bbd0eeae31735239c65653417"

  def initialize(model)
    @request_uri = PROVIDER_URI + '/' + model.target + "?access_key=#{ACCESS_KEY}&fields=main&hostname=#{model.host ? 1 : 0}"
  end

  def call
    code = JSON.parse(HTTP.get(@request_uri).to_s)
    puts code.inspect
    { country: code['country_name'], city: code['city'] }
  end
end