class CreateMusic < ActiveRecord::Migration
  def change
    create_table :musics do |t|
      t.string :name
      t.string :file_url
      t.belongs_to :music_type

      t.timestamps
    end
  end
end
