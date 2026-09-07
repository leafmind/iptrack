# frozen_string_literal: true

module ApiProviders
  class IpStack < Base
    BASE_URI = 'https://api.ipstack.com/'

    private

    def fetch_data(target, host)
      request_params = {
        access_key: @credentials.access_key,
        fields: :main,
        hostname: host ? 1 : 0,
      }
      request_uri = URI.join(BASE_URI, target)
      request_uri.query = request_params.to_query

      @results = JSON.parse(HTTP.get(request_uri).to_s)
    end

    def prepare_results
      {
        country: @results['country_name'],
        city: @results['city'],
        longitude: @results['longitude'],
        latitude: @results['latitude']
      }
    end
  end
end