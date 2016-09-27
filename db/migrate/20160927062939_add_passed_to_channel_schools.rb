class AddPassedToChannelSchools < ActiveRecord::Migration
  def change
    add_column :channel_schools, :passed, :boolean, default: false
  end
end
