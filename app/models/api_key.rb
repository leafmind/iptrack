# frozen_string_literal: true

class ApiKey < ApplicationRecord
  before_save :convert_token

  enum :role, { user: 0, admin: 1 }, default: :user

  has_many :geocodes, dependent: :destroy

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
