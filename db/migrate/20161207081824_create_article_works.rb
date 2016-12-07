class CreateArticleWorks < ActiveRecord::Migration[5.0]
  def change
    create_table :article_works do |t|
      t.references :article
      t.references :work

      t.timestamps
    end
  end
end
