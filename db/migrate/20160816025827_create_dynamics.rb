class CreateDynamics < ActiveRecord::Migration
  def change
    create_table :dynamics do |t|
      t.belongs_to :user

      t.text       :content
      t.string     :address
      t.boolean    :is_relay, default: false

      t.belongs_to :original_dynamic
      t.belongs_to :root_dynamic
      t.timestamps
    end
  end
end
