class CreateCreditManagers < ActiveRecord::Migration
  def change
    create_table :credit_managers do |t|
      t.belongs_to :user
      t.belongs_to :target_user
      t.integer :point, default: 0

      t.timestamps
    end
  end
end
