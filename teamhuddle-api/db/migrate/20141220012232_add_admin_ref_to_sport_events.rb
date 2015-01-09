class AddAdminRefToSportEvents < ActiveRecord::Migration
  def change
    add_reference :sport_events, :admin, index: true
  end
end
