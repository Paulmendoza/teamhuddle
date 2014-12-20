class AdminController < ApplicationController
  before_action :authenticate_admin!, :except => [:admin_signed_in]
 
  def index
    @users = User.all.order(created_at: :desc)
    
    @sport_events = SportEvent.all.where(deleted_at: nil)
  end

  def admin_stats
    @marc_events = SportEvent.all.where(admin_id: Admin.find_by_email('marc@teamhuddle.ca').id)
    @jon_events = SportEvent.all.where(admin_id: Admin.find_by_email('jon@teamhuddle.ca').id)
    @akos_events = SportEvent.all.where(admin_id: Admin.find_by_email('akos@teamhuddle.ca').id)
    @paul_events = SportEvent.all.where(admin_id: Admin.find_by_email('paul@teamhuddle.ca').id)
    @danny_events = SportEvent.all.where(admin_id: Admin.find_by_email('danny@teamhuddle.ca').id)
  end

  def admin_signed_in
    @signed_in = admin_signed_in?
  end
end
