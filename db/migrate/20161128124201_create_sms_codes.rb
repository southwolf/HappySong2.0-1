class CreateSmsCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :sms_codes do |t|
      t.string   "code",         limit: 10
      t.integer  "user_id"
      t.datetime "invalid_time"

      t.timestamps
    end
  end
end
