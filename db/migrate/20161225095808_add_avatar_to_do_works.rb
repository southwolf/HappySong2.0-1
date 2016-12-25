class AddAvatarToDoWorks < ActiveRecord::Migration[5.0]
  def change
    add_column :do_works, :avatar, :string
  end
end
