class AddOrderPriceToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :order_price, :decimal, :default => 0
  end
end
