# frozen_string_literal: true

class Geocode < ApplicationRecord
  belongs_to :api_key

  before_validation :resolve_host, if: :will_save_change_to_target?

  validate :target_valid

  private

  def target_valid
    if target.blank?
      errors.add(:target, 'can not be blank')
      return
    end

    if host
      uri = URI.parse(target)
      errors.add(:target, 'is not a valid IP/Host address') if !uri.is_a?(URI::HTTP)
    end
  end

  # INFO: to prevent assignment during validation
  def resolve_host
    host = !(target =~ Resolv::IPv4::Regex || target =~ Resolv::IPv6::Regex)
  end
end
