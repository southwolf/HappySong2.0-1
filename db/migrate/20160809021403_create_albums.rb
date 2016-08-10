class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string     :file_url
      t.belongs_to :user

      t.timestamps
    end
  end
end
