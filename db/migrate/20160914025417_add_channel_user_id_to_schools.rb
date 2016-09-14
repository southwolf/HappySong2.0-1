class AddChannelUserIdToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :channel_user_id, :integer
  end
end
