class CreateAssociators < ActiveRecord::Migration[5.0]
  def change
    create_table :associators do |t|
      t.date :start_time
      t.date :expire_time
      t.string :type
      t.references :student

      t.timestamps
    end
  end
end
