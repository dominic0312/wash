class AddRelationBetweenChargeOrder < ActiveRecord::Migration
  def change
    add_column :orders, :charge_id, :integer
    add_column :charges, :order_id, :integer
  end
end
