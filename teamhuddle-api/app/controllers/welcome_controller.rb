class WelcomeController < ApplicationController
  before_action :authenticate_admin!  
 
  def index
    @users = User.all.order(created_at: :desc)
    
    @sport_events = SportEvent.all.where(dt_deleted: nil)
    
  end
end
