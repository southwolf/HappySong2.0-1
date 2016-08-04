class CreateArticlesCateItems < ActiveRecord::Migration
  def change
    create_table :articles_cate_items,id: false do |t|
      t.belongs_to :cate_item
      t.belongs_to :article
    end
  end
end
