class AddChannelToBills < ActiveRecord::Migration
  def change
    add_column :bills, :channel, :string
    add_column :bills, :client_ip, :string
  end
end
