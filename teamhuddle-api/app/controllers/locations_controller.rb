class LocationsController < ApplicationController

  # GET /locations.json
  # GET /locations.xml
  # GET /locations
  def index
    @locations = Location.all

    respond_to do |format|
      format.html { render json: @locations }
      format.json { render json: @locations }
      format.xml { render xml: @locations }
    end

  end

  # POST /locations
  # example:
  # { "location": { "lat": 1, "long": 2, "name": "my house2" } }
  # validations:
  # :name NOT NULL, UNIQUE
  def create
    @location = Location.new(location_params)
    if @location.save
      render json: @location
    else
      render json: { error: @location.errors }, :status => :unprocessable_entity
    end
  end

  private
  # strong parameters
  def location_params
    params.require(:location).permit(:name, :lat, :long, :address)
  end

end
