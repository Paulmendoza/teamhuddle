class AddDeletedAtToSportEvents < ActiveRecord::Migration
  def change
    add_column :sport_events, :deleted_at, :datetime
    add_index :sport_events, :deleted_at

    execute "UPDATE sport_events SET deleted_at = dt_deleted;"

    remove_column :sport_events, :dt_deleted
  end
end
