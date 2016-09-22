class CreateCashManager < ActiveRecord::Migration
  def change
    create_table :cash_managers do |t|
      t.integer    :amount,  default: 0

      t.belongs_to :user
      t.belongs_to :target_user

      t.timestamps
    end
  end
end
