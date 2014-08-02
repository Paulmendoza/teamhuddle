class OrganizationsController < ApplicationController

  def index
    @organizations = Organization.all

    respond_to do |format|
      format.html
      format.json { render json: @organizations }
      format.xml { render xml: @organizations }
    end
  end
  
  def show
    @organization = Organization.find(params[:id])
    
    respond_to do |format|
      format.html
      format.json { render json: @organization }
      format.xml { render xml: @organization }
    end
  end

  def create
    @organization = Organization.new(organization_params)

    if @organization.save
      render json: @organization
    else
      render json: { error: @organization.errors }, :status => :unprocessable_entity
    end
  end

  def new
  end

  def edit
  end

  def update
    @organization = Location.find(params[:id])
    if @organization.update(organization_params)
      render json: @organization, :status => :ok
    else
      render json: { error: @organization.errors }, :status => :unprocessable_entity
    end
  end

  def destroy
    if Organization.find(params[:id]).destroy
      render :nothing => true, status => :no_conent
    end
  end

  private
  def organization_params
    params.require(:organization).permit(:name, :location_id, :user_id, :phone, :email)
  end

end
