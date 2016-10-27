class AddSomeIndexToNotifications < ActiveRecord::Migration
  def change
    add_index :notifications, :user_id
    add_index :notifications, :actor_id
  end
end
