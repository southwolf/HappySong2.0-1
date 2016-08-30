class AddCompleteToBills < ActiveRecord::Migration
  def change
    add_column :bills, :complete, :boolean, default: false
  end
end
