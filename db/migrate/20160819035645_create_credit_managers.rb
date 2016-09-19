class CreateCreditManagers < ActiveRecord::Migration
  def change
    create_table :credit_managers do |t|
      t.belongs_to :user
      t.string  :reson
      t.string  :type
      t.integer :point

      t.timestamps
    end
  end
end
