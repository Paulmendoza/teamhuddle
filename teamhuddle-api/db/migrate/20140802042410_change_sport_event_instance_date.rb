class ChangeSportEventInstanceDate < ActiveRecord::Migration
  def change
    change_table :sport_event_instances do |t|
      t.remove :datetime_start
      t.remove :datetime_end
      t.date :datetime_start
      t.date :datetime_end
    end
  end
end
