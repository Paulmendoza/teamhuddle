class ApplicationController < ActionController::Base
  include ActionController::MimeResponds
  
  layout 'admin'
  
  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers

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
  
  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = '*'
    headers['Access-Control-Max-Age'] = "1728000"
  end
  
  def cors_preflight_check
    if request.method == :options
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
      headers['Access-Control-Request-Method'] = '*'
      headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    end
  end
end
