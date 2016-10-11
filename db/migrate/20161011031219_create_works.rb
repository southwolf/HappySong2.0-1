class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.belongs_to :user
      t.string     :content
      t.string     :style
      t.time       :start
      t.time       :end
    end
  end
end
