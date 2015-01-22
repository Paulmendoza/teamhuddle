class ContactUsController < ApplicationController
  before_action :authenticate_admin!, :except => [:create]

  def index
    @forms = ContactUs.all
  end

  def create
    @form = ContactUs.new(contact_us_params)

    SignUpMailer.contact_us_notify(@form).deliver

    @form.save

    render json: @form
  end

  private
  def contact_us_params
    params.permit(:first_name, :last_name, :email, :comments)
  end
end
