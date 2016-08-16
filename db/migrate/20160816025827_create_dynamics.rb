class CreateDynamics < ActiveRecord::Migration
  def change
    create_table :dynamics do |t|
      t.belongs_to :user

      t.string     :content
      t.string     :address
      t.boolean    :is_relay, default: false
      t.integer    :ref_dynamic_id
      t.integer    :ref_user_id
      t.integer    :original_user_id

      t.timestamps
    end
  end
end
