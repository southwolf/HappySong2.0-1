class CreateHomeWorks < ActiveRecord::Migration[5.0]
  def change
    create_table :home_works do |t|
      t.references :teacher
      t.string :type, limit: 15
      t.datetime :end_time
      t.datetime :start_time
      t.references :article
      t.text :content

      t.timestamps
    end
  end
end
