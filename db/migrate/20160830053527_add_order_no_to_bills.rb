class AddOrderNoToBills < ActiveRecord::Migration
  def change
    add_column :bills, :order_no, :string
  end
end
