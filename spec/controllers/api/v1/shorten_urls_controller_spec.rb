require 'rails_helper'

describe Api::V1::ShortenUrlsController, type: :request do
  context :index do
    before do
      user = FactoryBot.create(:user)
    	api_setting = FactoryBot.create(:api_setting, user_id: user.id)
      @shorten_url = FactoryBot.create(:shorten_url, user_id: user.id)
      get '/api/v1/shorten_urls', headers: { 'Authorization' => "Token #{api_setting.api_key}, email=#{user.email}" }
    end

    it 'returns the correct status' do
      expect(response.status).to eql(200)
    end

    it 'returns the data in the body' do
      body = JSON.parse(response.body)
      expect(body['data'].count).to eql(ShortenUrl.count)
      expect(body['data'].first['attributes']['origin-url']).to eql(@shorten_url.origin_url)
      expect(body['data'].first['attributes']['url-code']).to eql(@shorten_url.url_code)
    end
  end

  context :create do
    let!(:user) { FactoryBot.create(:user) }
    let!(:other_user) { FactoryBot.create(:user) }
   	let!(:api_setting) { FactoryBot.create(:api_setting, user_id: user.id) }

    it 'returns the correct status' do
    	post '/api/v1/shorten_urls', params: { origin_url: 'https://facebook.com'},
      	headers: { 'Authorization' => "Token #{api_setting.api_key}, email=#{user.email}" }
      expect(response.status).to eql(200)
    end

    it 'returns the shorten_url' do
    	post '/api/v1/shorten_urls', params: { origin_url: 'https://facebook.com'},
      	headers: { 'Authorization' => "Token #{api_setting.api_key}, email=#{user.email}" }
    	body = JSON.parse(response.body)
      expect(body['data']).to have_key('url')
    end

    it 'origin url can not be blank' do
    	post '/api/v1/shorten_urls', params: { origin_url: ''},
      	headers: { 'Authorization' => "Token #{api_setting.api_key}, email=#{user.email}" }
      expect(response.status).to eql(422)
      body = JSON.parse(response.body)
      expect(body['msg']).to eql 'origin url can not be blank'
    end

    it 'email and api key mismatch' do
    	post '/api/v1/shorten_urls', params: { origin_url: '' },
      	headers: { 'Authorization' => "Token #{api_setting.api_key}, email=#{other_user.email}" }
      expect(response.status).to eql(401)
      body = JSON.parse(response.body)
      expect(body['msg']).to eql 'unauthorized'
    end
  end
end