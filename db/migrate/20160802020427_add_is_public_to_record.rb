class AddIsPublicToRecord < ActiveRecord::Migration
  def change
    add_column :records, :is_public, :boolean  
  end
end
