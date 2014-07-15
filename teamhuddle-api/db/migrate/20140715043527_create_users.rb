class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :salthashpass
      t.string :salt
      t.string :first_name
      t.string :locale
      t.string :email

      t.timestamps
    end
  end
end
