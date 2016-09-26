class AddAlipayToChannelUsers < ActiveRecord::Migration
  def change
    add_column :channel_users, :alipay, :string
  end
end
