class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.integer :location_id
      t.integer :user_id
      t.integer :phone
      t.string :email

      t.timestamps
    end
  end
end
