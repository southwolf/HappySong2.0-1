class AddSomeColumnToDynamics < ActiveRecord::Migration
  def change
    add_column :dynamics, :is_work, :boolean
    add_column :dynamics, :work_id, :boolean
  end
end
