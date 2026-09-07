class RequestGeocodeService
  PROVIDER_URI = "https://api.ipstack.com"
  ACCESS_KEY = "7d093c3bbd0eeae31735239c65653417"

  def initialize(ip_or_host)
  	@request_uri = PROVIDER_URI + '/' + ip_or_host + "?access_key=#{ACCESS_KEY}&fields=main"
  end

  def call
  	code = JSON.parse(HTTP.get(@request_uri).to_s)
  	puts code.inspect
  	{ country: code['country_name'], city: code['city'] }
  end
end