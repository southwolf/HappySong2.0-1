class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.belongs_to :user
      t.string     :content
      t.string     :style
      t.integer    :comments_count, default: 0
      t.datetime   :start_time
      t.datetime   :end_time

      t.timestamps
    end
  end
end
