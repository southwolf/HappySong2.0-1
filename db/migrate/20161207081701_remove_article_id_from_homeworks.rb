class RemoveArticleIdFromHomeworks < ActiveRecord::Migration[5.0]
  def change
    remove_column :home_works, :article_id
  end
end
