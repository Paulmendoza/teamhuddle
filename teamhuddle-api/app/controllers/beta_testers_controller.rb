class BetaTestersController < ApplicationController

	def new
		@beta_tester = BetaTester.new
	end

	def create 
		@beta_tester = BetaTester.new
    
    @beta_tester.email = params['beta_tester']['email']
    
		if @beta_tester.save
      #SignUpMailer.welcome(@beta_tester).deliver
			render json: @beta_tester
		else
			render json: { :errors => @beta_tester.errors }, :status => 422
		end
	end

end
