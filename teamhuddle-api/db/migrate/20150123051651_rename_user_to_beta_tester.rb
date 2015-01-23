class RenameUserToBetaTester < ActiveRecord::Migration
  def change
    rename_table :users, :beta_testers
  end
end
