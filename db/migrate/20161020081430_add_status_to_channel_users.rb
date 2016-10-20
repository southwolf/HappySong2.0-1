class AddStatusToChannelUsers < ActiveRecord::Migration
  def change
    add_column :channel_users, :status, :string
  end
end
