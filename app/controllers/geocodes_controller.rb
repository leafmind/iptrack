class GeocodesController < ApplicationController
  def index
    geocodes = GeocodeResource.all(params)

    respond_to do |format|
      format.jsonapi { render jsonapi: geocodes }
    end
  end
end
