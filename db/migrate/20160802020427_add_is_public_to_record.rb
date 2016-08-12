class AddIsPublicToRecord < ActiveRecord::Migration
  def change
    add_column :records, :is_public, :boolean, default: true  
  end
end
