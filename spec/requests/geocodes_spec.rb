# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Geocodes', type: :request do
  let(:endpoint) { '/api/v1/geocodes' }
  let(:user_api_key) { create(:api_key, role: :user, token: 'user-token') }
  let(:admin_api_key) { create(:api_key, role: :admin, token: 'api-token') }
  let(:user_headers) { { 'X-Api-Key' => 'user-token', 'Content-Type' => 'application/vnd.api+json', 'Accept' => 'application/vnd.api+json' } }
  let(:admin_headers) { { 'X-Api-Key' => 'admin-token', 'Content-Type' => 'application/vnd.api+json', 'Accept' => 'application/vnd.api+json' } }
  let(:service_double) { instance_double(RequestGeocodeService, call: { city: 'City', country: 'Country' }) }

  before do
    allow(RequestGeocodeService).to receive(:new).and_return(service_double)
    user_api_key.update!(token: 'user-token')
    admin_api_key.update!(token: 'admin-token')
    handle_request_exceptions(true)
  end

  describe 'GET /api/v1/geocodes' do
    context 'with admin API key' do
      let!(:geocode1) { create(:geocode, api_key: user_api_key, target: 'example.com') }
      let!(:geocode2) { create(:geocode, api_key: admin_api_key, target: '192.168.1.1') }
      let!(:geocode3) { create(:geocode, api_key: user_api_key, target: 'test.example.com') }

      it 'returns all geocodes' do
        get endpoint, headers: admin_headers

        expect(response).to have_http_status(:ok)
        data = jsonapi_data
        expect(data.map { |d| d.id }).to contain_exactly('example.com', '192.168.1.1', 'test.example.com')
      end
    end

    context 'with user API key' do
      subject { get endpoint, headers: user_headers }
      it 'returns 401 unauthorized' do
        get endpoint, headers: user_headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'without API key' do
      it 'returns 401 unauthorized' do
        get endpoint

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with invalid API key' do
      it 'returns 401 unauthorized' do
        get endpoint, headers: { 'X-Api-Key' => 'invalid-token' }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/geocodes/:target' do
    let!(:user_geocode) { create(:geocode, api_key: user_api_key, target: 'example.com', city: 'San Francisco', country: 'US') }
    let!(:admin_geocode) { create(:geocode, api_key: admin_api_key, target: '192.168.1.1', city: 'New York', country: 'US') }

    context 'with user API key' do
      it 'returns the user own geocode by target' do
        get "#{endpoint}/example.com", headers: user_headers

        expect(response).to have_http_status(:ok)
        data = jsonapi_data
        expect(data.id).to eq('example.com')
        expect(data.target).to eq('example.com')
        expect(data.city).to eq('San Francisco')
        expect(data.country).to eq('US')
      end

      it 'returns 404 for admins geocode' do
        get "#{endpoint}/192.168.1.1", headers: user_headers

        expect(response).to have_http_status(:not_found)
      end

      it 'returns 404 for non-existent geocode' do
        get "#{endpoint}/nonexistent.com", headers: user_headers

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'with admin API key' do
      it 'returns any geocode by target' do
        get "#{endpoint}/example.com", headers: admin_headers

        expect(response).to have_http_status(:ok)
        data = jsonapi_data
        expect(data.id).to eq('example.com')
        expect(data.target).to eq('example.com')
      end

      it 'returns admins own geocode' do
        get "#{endpoint}/192.168.1.1", headers: admin_headers

        expect(response).to have_http_status(:ok)
        data = jsonapi_data
        expect(data.id).to eq('192.168.1.1')
        expect(data.target).to eq('192.168.1.1')
      end

      it 'returns 404 for non-existent geocode' do
        get "#{endpoint}/nonexistent.com", headers: admin_headers

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'without API key' do
      it 'returns 401 unauthorized' do
        get "#{endpoint}/example.com"

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/v1/geocodes' do
    let(:valid_params) do
      {
        data: {
          type: 'geocodes',
          attributes: {
            target: 'example.com'
          }
        }
      }
    end

    context 'with user API key' do
      it 'creates a new geocode' do
        post endpoint, params: valid_params.to_json, headers: user_headers

        expect(response).to have_http_status(:created)
        data = jsonapi_data
        expect(data.id).to eq('example.com')
        expect(data.target).to eq('example.com')
        expect(data.city).to be_present
        expect(data.country).to be_present

        geocode = Geocode.find_by(target: 'example.com')
        expect(geocode.api_key).to eq(user_api_key)
      end

      it 'returns 422 for duplicate target' do
        create(:geocode, api_key: user_api_key, target: 'example.com')

        post endpoint, params: valid_params.to_json, headers: user_headers

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns 422 for invalid target format' do
        invalid_params = valid_params.deep_dup
        invalid_params[:data][:attributes][:target] = ''

        post endpoint, params: invalid_params.to_json, headers: user_headers

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with admin API key' do
      it 'creates a new geocode' do
        post endpoint, params: valid_params.to_json, headers: admin_headers

        expect(response).to have_http_status(:created)
        data = jsonapi_data
        expect(data.id).to eq('example.com')
        expect(data.target).to eq('example.com')

        geocode = Geocode.find_by(target: 'example.com')
        expect(geocode.api_key).to eq(admin_api_key)
      end
    end
  end

  describe 'PATCH /api/v1/geocodes/:target' do
    let!(:user_geocode) { create(:geocode, api_key: user_api_key, target: 'example.com', city: 'Old City') }
    let!(:admin_geocode) { create(:geocode, api_key: admin_api_key, target: '192.168.1.1', city: 'Admin City') }
    let(:update_params) do
      {
        data: {
          type: 'geocodes',
          id: 'example.com',
          attributes: {
            longitude: 13.37,
            latitude: 73.31
          }
        }
      }
    end

    context 'with user API key' do
      it 'returns 401 unauthorized' do
        patch "#{endpoint}/example.com", params: update_params.to_json, headers: user_headers

        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns 401 unauthorized for another users geocode' do
        patch "#{endpoint}/192.168.1.1", params: update_params.to_json, headers: user_headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with admin API key' do
      it 'updates the geocode' do
        patch "#{endpoint}/example.com", params: update_params.to_json, headers: admin_headers

        expect(response).to have_http_status(:ok)
        data = jsonapi_data
        expect(data.id).to eq('example.com')
      end

      it 'updates admins own geocode' do
        patch "#{endpoint}/192.168.1.1", params: update_params.to_json, headers: admin_headers

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'DELETE /api/v1/geocodes/:target (destroy)' do
    let!(:user_geocode) { create(:geocode, api_key: user_api_key, target: 'example.com') }
    let!(:admin_geocode) { create(:geocode, api_key: admin_api_key, target: '192.168.1.1') }
    let!(:other_admin_geocode) { create(:geocode, api_key: admin_api_key, target: 'test1.example.com') }
    let!(:other_user_geocode) { create(:geocode, api_key: user_api_key, target: 'test2.example.com') }

    context 'with user API key' do
      it 'deletes the users own geocode' do
        delete "#{endpoint}/example.com", headers: user_headers

        expect(response).to have_http_status(:ok)
        expect(Geocode.exists?(target: 'example.com')).to be false
      end

      it 'returns 404 for another users geocode' do
        delete "#{endpoint}/test1.example.com", headers: user_headers

        expect(response).to have_http_status(:not_found)
        expect(Geocode.exists?(target: 'test1.example.com')).to be true
      end

      it 'returns 404 for admins geocode' do
        delete "#{endpoint}/192.168.1.1", headers: user_headers

        expect(response).to have_http_status(:not_found)
        expect(Geocode.exists?(target: '192.168.1.1')).to be true
      end

      it 'returns 404 for non-existent geocode' do
        delete "#{endpoint}/nonexistent.com", headers: user_headers

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'with admin API key' do
      it 'deletes any geocode' do
        delete "#{endpoint}/example.com", headers: admin_headers

        expect(response).to have_http_status(:ok)
        expect(Geocode.exists?(target: 'example.com')).to be false
      end

      it 'deletes admins own geocode' do
        delete "#{endpoint}/192.168.1.1", headers: admin_headers

        expect(response).to have_http_status(:ok)
        expect(Geocode.exists?(target: '192.168.1.1')).to be false
      end

      it 'deletes another users geocode' do
        delete "#{endpoint}/test2.example.com", headers: admin_headers

        expect(response).to have_http_status(:ok)
        expect(Geocode.exists?(target: 'test2.example.com')).to be false
      end

      it 'returns 404 for non-existent geocode' do
        delete "#{endpoint}/nonexistent.com", headers: admin_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end