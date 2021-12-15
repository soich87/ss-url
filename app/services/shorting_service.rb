class ShortingService

	attr_reader :error

	def initialize(user, long_url)
		@long_url = long_url
		@user = user
		error = nil

		correct_url
	end

	def execute
		if valid_url?
			shorten_url = ShortenUrl.new(
				user_id: @user.id,
				origin_url: @long_url,
				url_code: generate_url_code
			)

			shorten_url.expired_at = set_expired_at

			if shorten_url.save
				shorten_url.url_code
			else
				error = shorten_url.errors.full_messages.first
			end

		else
			error = 'Invalid url'
		end
	end

	def valid_url?
		if @long_url.blank?
			error = 'Url input can be blank'
			false
		else
			uri = URI.parse(@long_url)
			host = uri && uri.host
      scheme = uri && uri.scheme
			true
		end
	end

	def set_expired_at
		Time.now + 6.months
	end

	private

	def correct_url
		unless @long_url.blank?
			uri = URI.parse(@long_url)
			unless uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS)
				@long_url = "https://#{@long_url}"
			end
		end
	end

	def generate_url_code	
		loop do
      code = [*'0'..'9', *'a'..'z', *'A'..'Z', ['-','=','+']].sample(6).join
      break code unless ShortenUrl.exists?(url_code: code)
    end
	end

end