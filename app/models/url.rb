class Url < ApplicationRecord
  validates :original_url, presence: true, uniqueness: true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
  validates :short_url, uniqueness: true

  before_validation :generate_short_url

  private

  def generate_short_url
    loop do
      self.short_url = SecureRandom.uuid[0..5] # Generate a 6-character unique string
      break unless Url.exists?(short_url: short_url)
    end
  end
end
