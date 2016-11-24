class AddTypeToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :type, :string, limit: 20, comment: 'User Role(Type)'
  end
end
