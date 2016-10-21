class AddSomeColumnToDynamics < ActiveRecord::Migration
  def change
    add_column :dynamics, :is_work, :boolean
    add_column :dynamics, :work_id, :integer
  end
end
