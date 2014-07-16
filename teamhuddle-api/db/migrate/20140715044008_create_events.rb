class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.integer :organization_id
      t.integer :location_id
      t.text :comments

      t.timestamps
    end
  end
end
