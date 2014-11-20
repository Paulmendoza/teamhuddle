class OrganizationsController < ApplicationController

  before_action :authenticate_admin!

  def index
    @organizations = Organization.all.order(:name)

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
      respond_to do |format|
        format.html { redirect_to action: 'index'}
        format.json { render json: @organization }
        format.xml { render xml: @organization }
      end
    else
      render json: { error: @organization.errors }, :status => :unprocessable_entity
    end
  end

  def new
    @organization = Organization.new
  end

  def edit
    @organization = Organization.find(params[:id])
  end

  def update
    @organization = Organization.find(params[:id])
    if @organization.update(organization_params)
      respond_to do |format|
        format.html { redirect_to :action => 'index'}
        format.json { render json: @organization, :status => :ok }
        format.xml { render json: @organization, :status => :ok }
      end
    else
      render json: { error: @organization.errors }, :status => :unprocessable_entity
    end
  end

  def destroy
    if Organization.find(params[:id]).destroy
      respond_to do |format|
        format.html { redirect_to :action => 'index'}
        format.json { render :nothing => true, status => :no_conent }
        format.xml { render :nothing => true, status => :no_conent }
      end
    end
  end

  private
  def organization_params
    params.require(:organization).permit(:name, :location_id, :phone, :email)
  end

end
