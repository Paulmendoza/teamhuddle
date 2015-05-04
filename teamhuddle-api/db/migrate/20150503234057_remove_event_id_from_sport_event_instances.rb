class RemoveEventIdFromSportEventInstances < ActiveRecord::Migration
  def change
    remove_column :sport_event_instances, :event_id
  end
end
