class ChangeContactUsToText < ActiveRecord::Migration
  def change
    change_column :contact_us, :comments, :text, :limit => nil
  end
end
