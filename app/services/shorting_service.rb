require "resolv"

class ShortingService

	attr_reader :error, :shortened_url, :long_url

	def initialize(user, long_url)
		@long_url = long_url
		@user = user
		@error = nil
		@shortened_url = nil
		ensure_protocol
	end

	def execute(create_by = nil)
		validation_url

		return if @error.present?

		shorten_url = ShortenUrl.new(
			user_id: @user.id,
			origin_url: @long_url,
			url_code: generate_url_code
		)

		shorten_url.expired_at = set_expired_at

		if shorten_url.save
			@shortened_url = shorten_url.shortened_url
		else
			@error = shorten_url.errors.full_messages.first
		end
	end

	def validation_url
		if @long_url.blank?
			@error = 'Url input can be blank'
		else
			uri = URI.parse(@long_url)
			@error = 'invalid host' unless valid_host?(uri.host)
		end
	end

	def set_expired_at
		# this is default expires - can be set by user or api setting
		Time.now + 6.months
	end

	private

	def valid_host? host
    return false unless host.present? && valid_characters?(host)
    labels = host.split('.')
    valid_length?(host) && valid_labels?(labels)
  end

  def valid_labels? labels
    labels.count >= 2 && labels.all?{ |label| label.length >= 1 && label.length <= 63 }
  end

  def valid_length? host
    host.length <= 253
  end

	def valid_characters? host
    !host[/[\s\!\\"$%&'\(\)*+_,:;<=>?@\[\]^|£§°ç\/]/] && host.last != '.'
  end

	def ensure_protocol
		unless @long_url.blank?
			uri = URI.parse(@long_url)
			unless uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS)
				@long_url = "https://#{@long_url}"
			end
		end
	end

	def generate_url_code	
		loop do
      code = [*'0'..'9', *'a'..'z', *'A'..'Z', ['=','+']].sample(6).join
      break code unless ShortenUrl.exists?(url_code: code)
    end
	end

end