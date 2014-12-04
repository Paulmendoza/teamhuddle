class FixReferentialIntegrity < ActiveRecord::Migration
  
  def change
    add_foreign_key :events, :locations
    add_foreign_key :events, :organizations
    
  end
  
end
