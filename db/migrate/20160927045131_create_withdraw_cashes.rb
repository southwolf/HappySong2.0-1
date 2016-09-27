class CreateWithdrawCashes < ActiveRecord::Migration
  def change
    create_table :withdraw_cashes do |t|
      t.belongs_to :user
      t.string     :alipay
      t.integer    :amount
      t.boolean    :passed, default: false

      t.timestamps null: false
    end
  end
end
