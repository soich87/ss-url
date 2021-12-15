require 'rails_helper'

RSpec.describe ShortingService, type: :model do
	describe '#execute' do
		let(:user) { FactoryBot.create(:user) }

		it 'ensure protocol corrected' do
			service = ShortingService.new(user, 'google.com')
			expect(service.long_url).to eq('https://google.com')
		end

		it 'create shorten url success' do
			service = ShortingService.new(user, 'google.com')
			service.execute
			expect(ShortenUrl.count).to eql(1)
			expect(service.error).to eql(nil)
			expect(service.shortened_url).to eql(ShortenUrl.last.shortened_url)
		end

		it 'input origin url can be blank' do
			service = ShortingService.new(user, '')
			service.execute
			expect(service.error).to eql('Url input can be blank')
		end

		context 'invalid host' do
			it 'missing zone' do
				service = ShortingService.new(user, 'https://google')
				service.execute
				expect(service.error).to eql('invalid host')
			end

			it 'missing name' do
				service = ShortingService.new(user, 'https://.com')
				service.execute
				expect(service.error).to eql('invalid host')
			end

			it 'error characters' do
				service = ShortingService.new(user, 'https://.///.com')
				service.execute
				expect(service.error).to eql('invalid host')
			end
		end
	end
end