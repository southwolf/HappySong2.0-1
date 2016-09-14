class CreateChannelUsers < ActiveRecord::Migration
  def change
    create_table :channel_users do |t|
      t.string :email
      t.string :name
      t.string :password_digest
      #渠道类型【个人/公司】
      t.boolean :company, default: false
      t.string :phone
      t.string :token
      t.boolean :admin, default: false
      t.belongs_to :district

      t.timestamps
    end
  end
end
