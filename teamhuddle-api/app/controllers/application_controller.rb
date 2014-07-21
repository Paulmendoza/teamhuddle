class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  rescue_from(ActionController::ParameterMissing) do |parameter_missing_exception|
    error = {}
    error[parameter_missing_exception.param] = ['parameter is required']
    response = { errors: error }
    respond_to do |format|
      format.json { render json: response, status: :unprocessable_entity }
    end
  end
end
