class ApiKey < ApplicationRecord
  before_save :convert_token

  class << self
  	def digest(plain_token)
  	  Digest::SHA256.hexdigest(plain_token)
  	end
  end

  private

  def convert_token
  	self.token = ApiKey.digest(self.token)
  end
end
