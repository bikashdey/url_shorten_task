require 'swagger_helper'

RSpec.describe '/api/v1/create_shorten_url', type: :request do
	path '/api/v1/create_shorten_url' do
	    post 'Create or retrieve a shortened URL' do
	      tags 'URL Shortener API'
	      consumes 'application/json'
	      produces 'application/json'
	      your_static_api_token = Rails.application.config.api_token

	      parameter name: :Authorization, in: :header, type: :string, required: true, description: 'API Token'

	      parameter name: :url, in: :body, schema: {
	        type: :object,
	        properties: {
	          original_url: { type: :string, example: 'https://example.com' }
	        },
	        required: ['original_url']
	      }

	      response '200', 'URL already shortened' do
	        let(:Authorization) { your_static_api_token }
	        let(:url) { { original_url: 'https://example.com' } }
	        run_test!
	      end

	      response '200', 'New URL shortened successfully' do
	        let(:Authorization) { your_static_api_token }
	        let(:url) { { original_url: 'https://newexample.com' } }
	        run_test!
	      end

	      response '401', 'Unauthorized request' do
	        let(:Authorization) { 'invalid_token' }
	        let(:url) { { original_url: 'https://example.com' } }
	        run_test!
	      end

	      response '422', 'Validation error' do
	        let(:Authorization) { your_static_api_token }
	        let(:url) { { original_url: '' } }
	        run_test!
	      end
	    end
 	end
end
