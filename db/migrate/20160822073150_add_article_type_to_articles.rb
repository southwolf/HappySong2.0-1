class AddArticleTypeToArticles < ActiveRecord::Migration
  def change
    # true  代表此篇文章是课内的文章
    # false 代表此篇文章是课外的文章
    add_column :articles, :article_type, :boolean, default: true
  end
end
