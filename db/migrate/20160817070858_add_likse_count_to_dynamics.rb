class AddLikseCountToDynamics < ActiveRecord::Migration
  def change
    add_column :dynamics, :likes_count, :integer, default: 0
  end
end
