class PushActions < ActiveRecord::Migration
  def change
    create_table :push_actions do |t|
      t.string :action
      t.timestamps
    end

    create_table :notify_configs do |t|
      t.belongs_to :user
      t.belongs_to :push_action
      t.timestamps
    end
  end
end
