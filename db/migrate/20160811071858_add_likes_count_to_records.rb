class AddLikesCountToRecords < ActiveRecord::Migration
  def change
    add_column :records, :likes_count, :integer
  end
end
