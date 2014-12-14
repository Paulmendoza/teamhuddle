class ContactUsController < ApplicationController

  def index
    if admin_signed_in?
      @forms = ContactUs.all
    else
      redirect_to :new_admin_session
    end

  end

  def create
    @form = ContactUs.new(contact_us_params)
    @form.save
    render json: @form
  end

  private
  def contact_us_params
    params.permit(:first_name, :last_name, :email, :comments)
  end
end
