class CreateNewNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :new_notifications do |t|
      t.references :actor
      t.integer :index
      t.integer :targetable_id
      t.string :targetable_type, limit: 40

      t.timestamps
    end
  end
end
