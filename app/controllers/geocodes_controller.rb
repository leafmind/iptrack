# frozen_string_literal: true

class GeocodesController < ApplicationController
  def index
    geocodes = GeocodeResource.all(params)
    authorize Geocode

    respond_to do |format|
      format.jsonapi { render jsonapi: geocodes }
    end
  end

  def show
    geocode = GeocodeResource.find(params)
    authorize :geocode, :show?

    respond_to do |format|
      format.jsonapi { render jsonapi: geocode }
    end
  end

  def create
    geocode = GeocodeResource.build(params)
    authorize :geocode, :create?

    if geocode.save
      render jsonapi: geocode, status: 201
    else
      render jsonapi_errors: geocode
    end
  end

  def update
    geocode = GeocodeResource.find(params)
    authorize :geocode, :update?

    if geocode.update_attributes
      render jsonapi: geocode
    else
      render jsonapi_errors: geocode
    end
  end

  def destroy
    geocode = GeocodeResource.find(params)
    authorize :geocode, :delete?

    if geocode.destroy
      render jsonapi: { meta: {} }, status: 200
    else
      render jsonapi_errors: geocode
    end
  end
end
