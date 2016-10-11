class CreateWorkAttachments < ActiveRecord::Migration
  def change
    create_table :work_attachments do |t|
      t.belongs_to :work
      t.boolean    :is_video
      t.string     :file_url

      t.timestamps
    end
  end
end
