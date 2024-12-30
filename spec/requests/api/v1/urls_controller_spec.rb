require 'rails_helper'

RSpec.describe Api::V1::UrlsController, type: :request do
  let(:headers) { { 'Authorization' => Rails.application.config.api_token } }
  let(:valid_url) { 'https://example.com' }
  let(:invalid_url) { '' }
  let(:existing_url) { Url.create!(original_url: valid_url, short_url: 'abc123') }

  describe 'POST /api/v1/create_shorten_url' do
    context 'when request is authenticated' do
      context 'and the URL already exists' do
        before do
          existing_url # Create the URL in the database
          post '/api/v1/create_shorten_url', params: { url: { original_url: valid_url } }, headers: headers
        end

        it 'returns the existing shortened URL' do
          expect(response).to have_http_status(200)
          expect(json_response['short_url']).to eq("#{request.base_url}/#{existing_url.short_url}")
          expect(json_response['message']).to eq('This URL has already been shortened.')
        end
      end

      context 'and the URL is new and valid' do
        before do
          post '/api/v1/create_shorten_url', params: { url: { original_url: valid_url } }, headers: headers
        end

        it 'creates and returns a new shortened URL' do
          expect(response).to have_http_status(200)
          expect(json_response['short_url']).to start_with(request.base_url)
        end
      end

      context 'and the URL is invalid' do
        before do
          post '/api/v1/create_shorten_url', params: { url: { original_url: invalid_url } }, headers: headers
        end

        it 'returns validation errors' do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_response['errors']).to include("Original url can't be blank")
        end
      end
    end

    context 'when request is not authenticated' do
      before do
        post '/api/v1/create_shorten_url', params: { url: { original_url: valid_url } }
      end

      it 'returns an unauthorized error' do
        expect(response).to have_http_status(:unauthorized)
        expect(json_response['error']).to eq('Unauthorized')
      end
    end
  end

  # Helper to parse JSON response
  def json_response
    JSON.parse(response.body)
  end
end
