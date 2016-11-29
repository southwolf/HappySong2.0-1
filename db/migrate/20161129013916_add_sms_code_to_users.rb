class AddSmsCodeToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :sms_code, :string, limit: 10
  end
end
