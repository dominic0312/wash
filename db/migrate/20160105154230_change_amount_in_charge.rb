class ChangeAmountInCharge < ActiveRecord::Migration
  def change
    remove_column :charges, :amount
    add_column :charges, :amount, :decimal, :default => 0.0, :null => false
  end
end
