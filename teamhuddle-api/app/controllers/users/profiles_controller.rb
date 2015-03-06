class Users::ProfilesController < ApplicationController
  layout 'client'

  before_action :authenticate_user!

  def profile
    @user = current_user

  end

  def player
    @user = User.find(params[:id])
  end
end
