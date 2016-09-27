class CreateChannelUserCashBacks < ActiveRecord::Migration
  def change
    create_table :channel_user_cash_backs do |t|
      t.belongs_to :channel_user
      t.integer    :amount, default: 0
      t.integer    :userd,  default: 0

      t.timestamps null: false
    end
  end
end
