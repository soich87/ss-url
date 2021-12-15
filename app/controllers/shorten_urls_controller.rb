class ShortenUrlsController < ApplicationController
  before_action :authenticate_user!, except: [:redirection]
  before_action :load_short_url, only: [:show, :edit, :update, :destroy]

  def redirection
    @shorten_url = ShortenUrl.find_by(url_code: params[:url_code])
    if @shorten_url.present?
      ShortenUrl.increment_counter(:clicked_count, @shorten_url.id)
      redirect_to @shorten_url.origin_url.to_s
    else
      redirect_to root_path, notice: 'Link not found'
    end
  end

  def index
    @shorten_urls = ShortenUrl.where(user_id: current_user.id)
  end

  def create
    service = ShortingService.new(current_user, params[:origin_url])

    service.execute
    
    if service.error.nil?
      redirect_to root_path
    else
      redirect_to root_path, notice: service.error
    end
  end

  def show; end

  def edit; end

  def destroy
    @shorten_url.destroy
    redirect_to root_path, notice: 'Record deleted'
  end

  private

  def shorten_url_params
    params.require(:shorten_url).permit(:origin_url).tap do |p|
      p[:user_id] = current_user.id
    end
  end

  def load_short_url
    @shorten_url = ShortenUrl.find_by(user_id: current_user.id, id: params[:id])
  end
end
