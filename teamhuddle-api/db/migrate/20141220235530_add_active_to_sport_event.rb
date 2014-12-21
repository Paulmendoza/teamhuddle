class AddActiveToSportEvent < ActiveRecord::Migration
  def change
    add_column :sport_events, :is_active, :boolean, {default: true, null: false}

  end
end
