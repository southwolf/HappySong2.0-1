class CreateNations < ActiveRecord::Migration[5.0]
  def change
    create_table :nations do |t|
      t.string :name
      t.integer :admin_code
      t.integer :code
      t.integer :tag
      t.integer :parent_id

      t.timestamps
    end
  end
end
