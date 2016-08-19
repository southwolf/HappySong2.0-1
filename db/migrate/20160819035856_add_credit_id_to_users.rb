class AddCreditIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :credit_id, :integer
  end
end
