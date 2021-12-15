class Api::V1::ShortenUrlsController < Api::V1::ApiController
  def index
  	shortened_urls = ShortenUrl.where(user_id: current_user).page(params[:page] || 1).per(30)
    render json: shortened_urls
  end

  def create

    return render json: { msg: 'Not enough balance'}, status: 422 if @current_api_setting.remaining_requests == 0

    unless params[:origin_url].blank?
    
      service = ShortingService.new(@current_user, params[:origin_url])
      service.execute(@current_api_setting.id)
    
      if service.error.nil?
        ApiSetting.decrement_counter(:remaining_requests, @current_api_setting.id)
        render json: { data: { url: service.shortened_url } }
      else
        render json: { msg: service.error }, status: 422
      end
    else
      render json: { msg: 'origin url can not be blank'}, status: 422
    end
  end
end
