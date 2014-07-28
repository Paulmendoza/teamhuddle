class LocationsController < ApplicationController

  def index
    @locations = Location.all

    respond_to do |format|
      format.html
      format.json { render json: @locations }
      format.xml { render xml: @locations }
    end
  end

  def create
    @location = Location.new(location_params)
    
    if @location.save 
      respond_to do |format|
        format.json { render json: @location }
        format.html { render action: 'index' }
      end
    else
      render json: { error: @location.errors }, :status => :unprocessable_entity
    end
    
  end

  def new 
    # default behavior
  end
  
  def edit
  end

  def show
    @location = Location.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @location }
      format.xml { render xml: @location }
    end
  end

  def update
    @location = Location.find(params[:id])
    if @location.update(location_params)
      render json: @location, :status => :ok
    else
      render json: { error: @location.errors }, :status => :unprocessable_entity
    end
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

