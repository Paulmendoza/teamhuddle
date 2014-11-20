class UpdateSportEventSportReference < ActiveRecord::Migration
  def change
    
    rename_column :sport_events, :sport, :sport_id
    
  end
end
