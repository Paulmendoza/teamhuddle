class UsersController < ApplicationController

	def new
		@user = User.new
	end

	def create 
		@user = User.new
		if @user.save
			redirect_to static_pages_path, notice: "Thanks!"
		else
			redirect_to static_pages_path
		end
	end

end
