class CreateChannelUsers < ActiveRecord::Migration
  def change
    create_table :channel_users do |t|
      t.string :email
      t.string :name
      t.string :password_digest
      #渠道类型【个人/公司】
      t.string :type
      t.string :phone
      t.string :token
      t.belongs_to :district
    end
  end
end
