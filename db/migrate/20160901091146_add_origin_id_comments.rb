class AddOriginIdComments < ActiveRecord::Migration
  def change
    add_column :comments, :top_comment_id, :integer
    add_column :comments, :is_reply, :boolean, default: false
  end
end
