class ShortenUrl < ApplicationRecord
	def shortened_url
		if Rails.env.development? || Rails.env.test?
			'localhost:3000/' + self.url_code 
		else
			# shortened url for other env
		end
	end
end