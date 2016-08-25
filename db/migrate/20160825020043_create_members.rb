class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.belongs_to :user
      t.datetime       :start_time
      t.datetime       :expire_time
      t.string     :member_type

      t.timestamps
    end
  end
end
