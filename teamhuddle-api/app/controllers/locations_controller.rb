class LocationsController < ApplicationController

  # GET /locations.json
  def index
    @locations = Location.all

    respond_to do |format|
      format.json { render json: @locations }
      format.xml { render xml: @locations }
    end
  end

  # POST /locations
  def create
    @location = Location.new(location_params)

    @location.save
    redirect_to @location
  end

  private
  def location_params
    params.require(:location).permit(:lat, :long, :name, :address)
  end

end
