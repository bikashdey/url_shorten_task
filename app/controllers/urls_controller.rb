class UrlsController < ApplicationController
	before_action :authenticate_api_request, only: [:api_create]
	
  def new
    @url = Url.new
  end

  def create
    existing_url = Url.find_by(original_url: url_params[:original_url])
    
    if existing_url
      @short_url = "#{request.base_url}/#{existing_url.short_url}"
      flash.now[:notice] = "This URL has already been shortened."
      render :new
    else
      @url = Url.new(url_params)
      if @url.save
        @short_url = "#{request.base_url}/#{@url.short_url}"
        flash.now[:notice] = "Your URL has been shortened successfully!"
        render :new
      else
        flash.now[:alert] = @url.errors.full_messages.to_sentence
        render :new
      end
    end
  end


  def redirect
    url = Url.find_by(short_url: params[:short_url])
    if url
      redirect_to url.original_url, allow_other_host: true
    else
      render plain: 'URL not found', status: :not_found
    end
  end

  private

  def url_params
    params.require(:url).permit(:original_url)
  end

end
