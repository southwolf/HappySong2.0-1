class CreateFreeLists < ActiveRecord::Migration[5.0]
  def change
    create_table :free_lists do |t|
      t.string :school_name
      t.datetime :expire_time

      t.timestamps
    end
    add_index :free_lists, :school_name
  end
end
