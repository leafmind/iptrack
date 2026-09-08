# frozen_string_literal: true

class Geocode < ApplicationRecord
  DOMAIN_REGEX = /\A([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}\z/i

  belongs_to :api_key

  before_validation :resolve_host, if: :will_save_change_to_target?

  validates :target, presence: true, format: { with: DOMAIN_REGEX, message: "must be a valid domain name" }, if: -> { host }
  validate :target_valid, if: -> { !host }

  private

  def target_valid
    errors.add(:target, 'is not a valid IP address') if !ip_address?
  end

  # INFO: to prevent assignment during validation
  def resolve_host
    update_attribute(:host, !ip_address?)
  end

  def ip_address?
    target =~ Resolv::IPv4::Regex || target =~ Resolv::IPv6::Regex
  end
end
