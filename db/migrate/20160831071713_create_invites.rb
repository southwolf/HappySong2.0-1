class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.belongs_to :user        #邀请人
      t.belongs_to :target_user #被邀请人
      t.integer    :cash_back_count, default: 0
      t.boolean    :is_student, default: false
      t.timestamps null: false
    end
  end
end
