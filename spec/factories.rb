FactoryBot.define do
  factory :user do
    full_name { Faker::Name.name }
    email { Faker::Internet.safe_email }
    password { 'admin1234' }
    password_confirmation { 'admin1234' }
  end

  factory :api_setting do
  	expired_at { 6.months.from_now }
  	remaining_requests { 1000 }
  end

  factory :shorten_url do
    url_code { 'hysnsf' }
    origin_url { 'https://google.com' }
    expired_at { 6.months.from_now }
  end
end