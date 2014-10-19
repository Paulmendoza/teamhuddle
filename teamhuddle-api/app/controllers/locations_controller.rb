class LocationsController < ApplicationController

<<<<<<< HEAD
  before_action :admin_only
=======
  before_action :authenticate_admin!
>>>>>>> 0426f9bb81d9530d0858b0ca01861b20eeafc1b6

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
        format.html { redirect_to action: 'index' }
      end
    else
      render json: { error: @location.errors }, :status => :unprocessable_entity
    end
    
    session[:location] = @location
    
  end

  def new 
    @location = Location.new
    # default behavior
  end
  
  def edit
    @location = Location.find(params[:id])
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
      respond_to do |format|
        format.html { redirect_to :action => 'index'}
        format.json { render json: @location, :status => :ok}
        format.xml { render json: @location, :status => :ok }
      end
      
    else
      render json: { error: @location.errors }, :status => :unprocessable_entity
    end
  end

  def destroy
    @location = Location.find(params[:id])
    @location.destroy
    
    respond_to do |format|
      format.html { redirect_to :action => 'index'}
      format.json { render :nothing => true, status => :no_conent }
      format.xml { render :nothing => true, status => :no_conent }
    end
  end
  
  # strong paramaters
  private
  def location_params
    params.require(:location).permit(:name, :lat, :long, :address)
  end

  def admin_only
    unless admin_signed_in?
      redirect_to new_admin_session_path
    end
  end
end

