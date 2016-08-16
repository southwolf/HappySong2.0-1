class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.belongs_to :dynamic
      t.boolean    :is_video, default: false
      t.string     :file_url

      t.timestamps
    end
  end
end
