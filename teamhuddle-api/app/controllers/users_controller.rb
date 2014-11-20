class UsersController < ApplicationController

	def new
		@user = User.new
	end

	def create 
		@user = User.new
    
    @user.email = params['user']['email']
    
		if @user.save
			redirect_to url_for(:controller => :index, :action => :landing), notice: "Thanks!"
		else
			redirect_to 'index#landing'
		end
	end

end
