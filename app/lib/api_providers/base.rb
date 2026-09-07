# frozen_string_literal: true

module ApiProviders
  class Base
    def initialize(credentials)
      @credentials = credentials
      @results = {}
    end

    def fetch_results(target, host)
      fetch_data(target, host)
      prepare_results
    end

    private

    def fetch_data
      raise 'Not Implemented'
    end

    def prepare_results
      raise 'Not Implemented'
    end
  end
end