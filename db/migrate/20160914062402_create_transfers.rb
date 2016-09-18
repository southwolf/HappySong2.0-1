class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      
      t.belongs_to :transfer_user
      t.belongs_to :collector
      #转账金额
      t.string :amount


      t.timestamps null: false
    end
  end
end
