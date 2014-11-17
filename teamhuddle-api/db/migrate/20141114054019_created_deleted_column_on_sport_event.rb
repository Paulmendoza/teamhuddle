class CreatedDeletedColumnOnSportEvent < ActiveRecord::Migration
  def change
    add_column :sport_events, :dt_deleted, :datetime    
  end
end
