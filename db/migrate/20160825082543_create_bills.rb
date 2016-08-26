class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.belongs_to :user
      t.integer    :target_user_id
      t.integer    :amount
      t.string     :bill_type

      t.timestamps
    end
  end
end
