class AddDtExpiryToSportEvent < ActiveRecord::Migration
  def up
    add_column :sport_events, :dt_expiry, :datetime

    SportEvent.with_deleted.all.each do |sport_event|

      puts 'Updating #{sport_event.id}'
      schedule = sport_event.schedule

      sport_event.update(dt_expiry: schedule.last)
    end

    change_column :sport_events, :dt_expiry, :datetime, null: false
  end

  def down
    remove_column :sport_events, :dt_expiry
  end
end
