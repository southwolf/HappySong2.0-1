class CreateWorkToArticle < ActiveRecord::Migration
  def change
    create_table :work_to_articles do |t|
      t.belongs_to :article
      t.belongs_to :work

      t.timestamps
    end
  end
end
