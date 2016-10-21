class AddSomeColumnToDynamics < ActiveRecord::Migration
  def change
    add_column :dynamics, :is_work, :boolean, default: false
    add_column :dynamics, :work_id, :integer
  end
end
