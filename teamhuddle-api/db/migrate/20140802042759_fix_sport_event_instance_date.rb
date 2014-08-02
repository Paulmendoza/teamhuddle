class FixSportEventInstanceDate < ActiveRecord::Migration
  def change
    change_table :sport_event_instances do |t|
      t.remove :datetime_start
      t.remove :datetime_end
      t.datetime :datetime_start
      t.datetime :datetime_end
    end
  end
end
