class CreateSportEventInstances < ActiveRecord::Migration
  def change
    create_table :sport_event_instances do |t|
      t.integer :sport_event_id
      t.integer :datetime_start
      t.integer :datetime_end

      t.timestamps
    end
  end
end
