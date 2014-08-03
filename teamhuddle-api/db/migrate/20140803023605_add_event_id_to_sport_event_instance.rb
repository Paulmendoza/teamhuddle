class AddEventIdToSportEventInstance < ActiveRecord::Migration
  def change
    add_column :sport_event_instances, :event_id, :integer
  end
end
