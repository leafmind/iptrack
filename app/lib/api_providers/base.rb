# frozen_string_literal: true

module ApiProviders
  class Base
    class GatewayError < StandardError; end

    def initialize(credentials)
      @credentials = credentials
      @results = {}
    end

    def fetch_results(target, host)
      fetch_data(target, host)
      if success?
        prepare_results
      else
        raise GatewayError
      end
    end

    private

    def success?
      raise 'Not Implemented'
    end

    def fetch_data
      raise 'Not Implemented'
    end

    def prepare_results
      raise 'Not Implemented'
    end
  end
end