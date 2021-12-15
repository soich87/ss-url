class ApiSetting < ApplicationRecord

	before_create :set_expire_time, :set_rating_limited, :generate_api_key

	def expire?
		expired_at < Time.now
	end

	private

	def generate_api_key
		self.api_key = loop do
      api_key = [*'0'..'9', *'a'..'z', *'A'..'Z'].sample(19).join
      break api_key unless self.class.exists?(api_key: api_key)
    end
	end	

	def set_rating_limited
		# default request limited per day
		self.remaining_requests = 1000
	end

	def set_expire_time
		self.expired_at = 1.years.from_now
	end
end