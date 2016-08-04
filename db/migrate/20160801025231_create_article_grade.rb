class CreateArticleGrade < ActiveRecord::Migration
  def change
    create_table :article_grades do |t|
      t.string :name

      t.timestamps
    end
  end
end
