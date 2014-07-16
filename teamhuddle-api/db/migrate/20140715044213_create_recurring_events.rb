class CreateRecurringEvents < ActiveRecord::Migration
  def change
    create_table :recurring_events do |t|
      t.integer :event_id
      t.integer :date_start
      t.integer :date_end
      t.integer :time_start
      t.integer :time_end
      t.text :ical_string
      t.string :integer_type

      t.timestamps
    end
  end
end
