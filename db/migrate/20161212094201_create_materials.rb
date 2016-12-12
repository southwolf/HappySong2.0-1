class CreateMaterials < ActiveRecord::Migration[5.0]
  def change
    create_table :materials do |t|
      t.integer :materialable_id
      t.string :materialable_type, limit: '40'
      t.string :kind, limit: '20', comment: 'Vidio | Image | Sound'
      t.string :url

      t.timestamps
    end
  end
end
