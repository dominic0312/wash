class AddShipmentToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :shipment, :decimal
  end
end
