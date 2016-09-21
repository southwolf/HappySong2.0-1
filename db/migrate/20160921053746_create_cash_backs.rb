class CreateCashBacks < ActiveRecord::Migration
  def change
    create_table :cash_backs do |t|
      t.integer    :cash
      t.belongs_to :user


      t.timestamps
    end
  end
end
