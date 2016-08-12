class CreateArticle < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :cover_img
      t.string :content
      t.belongs_to :subject
      t.belongs_to :article_grade
      t.belongs_to :edition
      t.belongs_to :unit

      t.timestamps
    end
  end
end
