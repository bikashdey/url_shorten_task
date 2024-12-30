require 'rails_helper'

RSpec.describe Url, type: :model do
  describe 'validations' do
    it 'is valid with a unique original_url and generated short_url' do
      url = Url.new(original_url: 'https://example.com')
      expect(url).to be_valid
    end

    it 'is not valid without an original_url' do
      url = Url.new(original_url: nil)
      expect(url).not_to be_valid
      expect(url.errors[:original_url]).to include("can't be blank")
    end

    it 'is not valid with a duplicate original_url' do
      Url.create!(original_url: 'https://example.com')
      duplicate_url = Url.new(original_url: 'https://example.com')
      expect(duplicate_url).not_to be_valid
      expect(duplicate_url.errors[:original_url]).to include('has already been taken')
    end

    it 'is not valid with an invalid original_url format' do
      url = Url.new(original_url: 'invalid_url')
      expect(url).not_to be_valid
      expect(url.errors[:original_url]).to include('is invalid')
    end

	it 'is not valid with a duplicate short_url' do
	  # Create an existing URL
	  existing_url = Url.create!(original_url: 'https://example.com')

	  # Create a new URL instance and manually assign a duplicate short_url
	  new_url = Url.new(original_url: 'https://another-example.com')
	  new_url.short_url = existing_url.short_url

	  # Attempt to save the new URL, expecting a database error due to duplicate short_url
	  expect {
	    new_url.save!(validate: false) # Skip model validations to rely on database constraint
	  }.to raise_error(ActiveRecord::RecordNotUnique)
	end


  end

  describe 'generate_short_url' do
    it 'generates a unique short_url before validation' do
      url = Url.create!(original_url: 'https://unique-url.com')
      expect(url.short_url).to be_present
      expect(url.short_url.length).to eq(6)
    end

    it 'ensures the short_url is unique across records' do
      allow(SecureRandom).to receive(:uuid).and_return('abcdef123456', 'abcdef123456', '123456abcdef')
      Url.create!(original_url: 'https://first-url.com')
      second_url = Url.create!(original_url: 'https://second-url.com')
      expect(second_url.short_url).not_to eq('abcdef') # Avoids collision
    end
  end
end
