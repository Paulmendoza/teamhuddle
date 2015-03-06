class Users::SessionsController < Devise::SessionsController
  layout 'client'
# before_filter :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end

  def is_signed_in
    @response_hash = Hash.new

    if user_signed_in?
      @response_hash = {signed_in: true, user_id: current_user.id}
    else
      @response_hash = {signed_in: false, user_id: nil}
    end

    render json: @response_hash

  end
end
