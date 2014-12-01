class UsersController < ApplicationController

	def new
		@user = User.new
	end

	def create 
		@user = User.new
    
    @user.email = params['user']['email']
    
		if @user.save
			render json: @user
		else
			render json: @user
		end
	end

end
