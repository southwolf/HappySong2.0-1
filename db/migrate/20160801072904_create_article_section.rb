class CreateArticleSection < ActiveRecord::Migration
  def change
    create_table :article_sections do |t|
      t.string :title
      t.string :author
      t.string :content
      t.belongs_to :article

      t.timestamps
    end
  end
end
