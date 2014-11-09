class CreateSports < ActiveRecord::Migration
  def change
    create_table :sports, id: false, force: true do |t|
      t.string :sport, null: false
      t.timestamps
    end
    
    add_index :sports, [:sport], name: "index_sports_on_sport", unique: true, using: :btree
  end
end
