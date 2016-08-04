class CreateRecord < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.string :file_url
      t.string :feeling
      t.string :style

      t.belongs_to :user
      t.belongs_to :article
      t.belongs_to :music

      t.timestamps
    end
  end
end
