class AddHasDemoToRecords < ActiveRecord::Migration
  def change
    add_column :records, :has_demo, :boolean, default: false
  end
end
