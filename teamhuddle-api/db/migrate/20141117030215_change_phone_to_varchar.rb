class ChangePhoneToVarchar < ActiveRecord::Migration
  def change
        change_column :organizations, :phone, :string 
  end
end
