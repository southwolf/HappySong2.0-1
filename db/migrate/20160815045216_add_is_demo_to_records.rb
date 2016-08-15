class AddIsDemoToRecords < ActiveRecord::Migration
  def change
    add_column :records, :is_demo, :boolean, default: false
    add_column :records, :is_hot,  :boolean, default: false
  end
end
