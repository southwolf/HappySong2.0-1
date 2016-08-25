class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string     :notification_type, null: false
      t.belongs_to :user
      t.references :targetable, polymorphic: true
      t.boolean    :unread, default: true

      t.timestamps
    end
  end
end
