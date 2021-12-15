class Api::V1::ShortenUrlSerializer < ActiveModel::Serializer
	attributes :id, :origin_url, :url_code, :expired_at, :shortened_url
end