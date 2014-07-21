class OrganizationsController < ApplicationController

  # GET /organizations.json
  # GET /organizations.xml
  # GET /organizations
  def index
    @organizations = Organization.all

    respond_to do |format|
      format.html { render json: @organizations }
      format.json { render json: @organizations }
      format.xml { render xml: @organizations }
    end

  end

  # POST /organizations
  # example:
  # { "organization": { "name": UrbanRec, "location": 1, "phone": 6047635464 } }
  # validations:
  # :name NOT NULL, UNIQUE
  # :email UNIQUE
  def create
    @organization = Organization.new(organization_params)
    if @organization.save
      render json: @organization
    else
      render json: { error: @organization.errors }, :status => :unprocessable_entity
    end
  end

  private
  def organization_params
    params.require(:organization).permit(:name, :location, :user, :phone, :email)
  end

end
