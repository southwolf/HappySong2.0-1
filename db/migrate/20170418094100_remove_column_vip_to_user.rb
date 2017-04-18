class RemoveColumnVipToUser < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :vip
  end
end
