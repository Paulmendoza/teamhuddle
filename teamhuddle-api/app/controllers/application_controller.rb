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
end
