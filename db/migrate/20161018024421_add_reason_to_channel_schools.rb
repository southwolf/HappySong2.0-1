class AddReasonToChannelSchools < ActiveRecord::Migration
  def change
    add_column :channel_schools, :reason, :string
  end
end
