class DropRecurringEventsTable < ActiveRecord::Migration
  def up
    drop_table :recurring_events
  end
end
