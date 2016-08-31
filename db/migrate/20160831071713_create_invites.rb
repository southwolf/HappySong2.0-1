class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.belongs_to :user        #邀请人
      t.belongs_to :target_user #被邀请人

      t.timestamps null: false
    end
  end
end
