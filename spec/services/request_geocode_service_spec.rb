# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RequestGeocodeService do
  let(:model) { instance_double('Model', target: 'some.host.com', host: true) }
  let(:provider) { instance_double(ApiProviders::IpStack) }

  before do
    allow(ApiProviders::IpStack)
      .to receive(:new)
      .with(Rails.configuration.x.api_provider)
      .and_return(provider)
  end

  describe '#call' do
    it 'fetches geocode results for the model' do
      expect(provider)
        .to receive(:fetch_results)
        .with(model.target, model.host)

      described_class.new(model).call
    end
  end
end
