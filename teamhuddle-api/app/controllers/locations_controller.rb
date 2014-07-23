class LocationsController < ApplicationController

  def index
    @locations = Location.all

    respond_to do |format|
      format.html { render json: @locations }
      format.json { render json: @locations }
      format.xml { render xml: @locations }
    end
  end

  def create
    @location = Location.new(location_params)
    if @location.save
      render json: @location
    else
      render json: { error: @location.errors }, :status => :unprocessable_entity
    end
  end

  def new
    @response = {}
    location = {}
    location["lat"] = 0
    location["long"] = 0
    location["address"] = ""
    location["name"] = ""
    @response["location"] = location
    respond_to do |format|
      format.json { render json: @response }
    end
  end

  def edit
  end

  def show
    @location = Location.find(params[:id])

    respond_to do |format|
      format.html { render json: @locations }
      format.json { render json: @locations }
      format.xml { render xml: @locations }
    end
  end

  def update
  end

  def destroy
    if Location.find(params[:id]).destroy
      render :nothing => true, status => :no_conent
    end
  end


  # strong paramaters
  private
  def location_params
    params.require(:location).permit(:name, :lat, :long, :address)
  end

end

