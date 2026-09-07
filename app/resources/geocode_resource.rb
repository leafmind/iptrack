class GeocodeResource < ApplicationResource
  model Geocode

  default_sort [{ name: :target }]
  page_default_size 10

  attribute :target, :string
  attribute :host, :boolean, wtiteable: false
  attribute :longitude, :float
  attribute :latitude, :float

  attribute :city, :string
  attribute :country, :string
end
