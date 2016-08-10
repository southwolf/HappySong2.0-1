class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.belongs_to :like_user
      t.references :likeable, polymorphic: true

      t.timestamps
    end
  end
end
