class AddSnAmountToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :sn, :string
    add_column :orders, :amount, :decimal, :default => 0
  end
end
