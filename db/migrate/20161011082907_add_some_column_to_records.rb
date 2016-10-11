class AddSomeColumnToRecords < ActiveRecord::Migration
  def change
    add_column :records, :is_work, :boolean, default: false
    add_column :records, :work_id, :integer
  end
end
