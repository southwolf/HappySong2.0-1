class CreateConfigs < ActiveRecord::Migration
  def change
    create_table :configs do |t|
      t.integer :num, defalut: 1

      t.timestamps
    end
  end
end
