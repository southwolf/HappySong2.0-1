class AddChargeIdToBills < ActiveRecord::Migration[5.0]
  def change
    add_column :bills, :charge_id, :string
  end
end
