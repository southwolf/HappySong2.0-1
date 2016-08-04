class AddContactToAdvises < ActiveRecord::Migration
  def change
    add_column :advises, :contact, :string
  end
end
