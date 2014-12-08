class LocationsController < ApplicationController
  
  before_action :authenticate_admin!

  def index
    @locations_grid = initialize_grid(Location,
                                      :enable_export_to_csv => true,
                                      :csv_field_separator => ';',
                                      :csv_file_name => 'locations',
                                      :name => 'locations')

    @locations = Location.all.order(:name)

    export_grid_if_requested('locations' => 'locations_grid') do
      respond_to do |format|
        format.html
        format.json { render json: @locations }
        format.xml { render xml: @locations }
      end
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

    if @location.destroy
      respond_to do |format|
        format.html { redirect_to :action => 'index'}
        format.json { render :nothing => true, status => :no_content }
        format.xml { render :nothing => true, status => :no_content }
      end
    else
      render json: { error: @location.errors }, :status => :unprocessable_entity
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

