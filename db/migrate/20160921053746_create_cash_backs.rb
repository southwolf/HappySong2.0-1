class CreateCashBacks < ActiveRecord::Migration
  def change
    create_table :cash_backs do |t|
      t.integer :cash, default: 0
      t.integer :used,  default: 0
      t.belongs_to :user

      t.timestamps
    end
  end
end
