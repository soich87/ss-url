class Api::V1::ApiController <  ActionController::API
	
	before_action :authenticate_user!

	protected

	def pagination_dict(collection)
	  {
	    current_page: collection.current_page,
	    next_page: collection.next_page,
	    prev_page: collection.prev_page,
	    total_pages: collection.total_pages,
	    total_count: collection.total_count
	  }
	end

	def authenticate_user!
	  token, options = ActionController::HttpAuthentication::Token.token_and_options(
	    request
	  )

	  return render json: { msg: 'unauthorized' }, status: 401 unless token && options.is_a?(Hash)
	  
	  user = User.find_by(email: options['email'])
	  api_setting = ApiSetting.find_by(api_key: token)

	  if user && api_setting && api_setting.user_id == user.id
	    @current_user = user
	    @current_api_setting = api_setting
	  else
	    return render json: { msg: 'unauthorized' }, status: 401
	  end
	end
end