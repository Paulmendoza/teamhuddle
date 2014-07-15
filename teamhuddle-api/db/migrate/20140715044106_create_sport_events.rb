class CreateSportEvents < ActiveRecord::Migration
  def change
    create_table :sport_events do |t|
      t.integer :event_id
      t.string :sport
      t.string :type
      t.string :skill_level
      t.decimal :price_per_one
      t.decimal :price_per_group
      t.integer :spots
      t.integer :spots_filled
      t.string :gender
      t.text :notes
      t.string :format

      t.timestamps
    end
  end
end
