class CreateApplyCashBacks < ActiveRecord::Migration
  def change
    create_table :apply_cash_backs do |t|
      t.belongs_to :channel_user
      t.integer :amount
      t.string  :alipay
      #是否通过申请
      t.boolean :passed

      t.timestamps
    end
  end
end
