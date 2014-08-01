class AddScheduleToSportEvents < ActiveRecord::Migration
  def change
    add_column :sport_events, :schedule, :text
  end
end
