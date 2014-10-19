class ApplicationController < ActionController::Base
  include ActionController::MimeResponds
  layout 'admin'

  rescue_from(ActionController::ParameterMissing) do |parameter_missing_exception|
    error = {}
    error[parameter_missing_exception.param] = [parameter_missing_exception.message]
    response = { errors: error }
    respond_to do |format|
      format.html { render json: response, status: :unprocessable_entity }
      format.json { render json: response, status: :unprocessable_entity }
    end
  end

  rescue_from(ActiveRecord::RecordNotFound) do |record_not_found_exception|
    error = {}
    error[0] = ['record not found']
    response = { errors: error }
    respond_to do |format|
      format.html { render json: response, status: :not_found }
      format.json { render json: response, status: :not_found }
    end
  end

  def after_sign_in_path_for(resource)
    sign_in_url = url_for(:action => 'new', :controller => 'sessions', :only_path => false, :protocol => 'http')
    if request.referer == sign_in_url
      super
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    request.referrer
  end

end
