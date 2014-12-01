class AddSourceToSportEvent < ActiveRecord::Migration
  def change
    add_column :sport_events, :source, :string
  end
end
