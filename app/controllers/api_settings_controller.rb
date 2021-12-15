class ApiSettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_api_setting, only: [:show, :destroy]

  def index
  	@api_settings = ApiSetting.where(user_id: current_user.id)
  end

  def show ;end

  def create
  	total_apis = ApiSetting.where(user_id: current_user.id).count
  	if total_apis > 3
  		flash[:danger] = 'Total api key limited to 3'
  		redirect_to api_settings_path
  	else
  		api_setting = ApiSetting.create(user_id: current_user.id)
  		redirect_to api_settings_path
  	end
  end

  def destroy
  	@api_setting.destroy
  	redirect_to api_settings_path
  end

  private

  def load_api_setting
  	@api_setting = ApiSetting.find_by(user_id: current_user.id, id: params[:id])
  end

end