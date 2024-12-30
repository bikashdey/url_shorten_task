class Api::V1::UrlsController < ApplicationController
  before_action :authenticate_api_request

  def create
    existing_url = Url.find_by(original_url: url_params[:original_url])

    if existing_url
      render json: { short_url: "#{request.base_url}/#{existing_url.short_url}", message: 'This URL has already been shortened.' }, status: 200
    else
      @url = Url.new(url_params)
      if @url.save
        render json: { short_url: "#{request.base_url}/#{@url.short_url}" }, status: 200
      else
        render json: { errors: @url.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  private

  def url_params
    params.require(:url).permit(:original_url)
  end

  def authenticate_api_request
    token = request.headers['Authorization']
    unless token && valid_token?(token)
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def valid_token?(token)
    token == Rails.application.config.api_token
  end
end
