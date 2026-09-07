# frozen_string_literal: true

class GeocodeResource < ApplicationResource
  before_save do |model|
    model.api_key ||= context.current_api_key
    geo_attrs = RequestGeocodeService.new(model).call
    model.assign_attributes(geo_attrs)
  end

  public_id :target

  attribute :target, :string
  attribute :host, :boolean, writeable: false
  attribute :longitude, :float
  attribute :latitude, :float

  attribute :city, :string
  attribute :country, :string

  def base_scope
    api_key = context.current_api_key
    if api_key.admin?
      Geocode.all
    else
      Geocode.where(api_key: api_key)
    end
  end
end
