class OrganizationsController < ApplicationController

  before_action :authenticate_admin!

  def index
    @organizations_grid = initialize_grid(Organization,
                                          :enable_export_to_csv => true,
                                          :csv_field_separator => ';',
                                          :csv_file_name => 'organizations',
                                          :name => 'organizations'
    )

    @organizations = Organization.all.order(:name)

    export_grid_if_requested('organizations' => 'organizations_grid') do
      respond_to do |format|
        format.html
        format.json { render json: @organizations }
        format.xml { render xml: @organizations }
      end
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
        format.html { redirect_to action: 'index' }
        format.json { render json: @organization }
        format.xml { render xml: @organization }
      end
    else
      render json: {error: @organization.errors}, :status => :unprocessable_entity
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
        format.html { redirect_to :action => 'index' }
        format.json { render json: @organization, :status => :ok }
        format.xml { render json: @organization, :status => :ok }
      end
    else
      render json: {error: @organization.errors}, :status => :unprocessable_entity
    end
  end

  def destroy
    @organization = Organization.find(params[:id])
    if @organization.destroy
      respond_to do |format|
        format.html { redirect_to :action => 'index' }
        format.json { render :nothing => true, status => :no_conent }
        format.xml { render :nothing => true, status => :no_conent }
      end
    else
      render json: {error: @organization.errors}, :status => :unprocessable_entity
    end


  end

  private
  def organization_params
    params.require(:organization).permit(:name, :location_id, :phone, :email, :website)
  end

end
