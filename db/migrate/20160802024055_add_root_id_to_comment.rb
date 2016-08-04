class AddRootIdToComment < ActiveRecord::Migration
  def change
    add_column :comments, :root_id, :integer
  end
end
