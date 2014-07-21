class FixRecurrenceModel < ActiveRecord::Migration
  def change
    change_table :recurring_events do |t|
      t.remove :integer_type
      t.string :interval_type
    end
  end
end
