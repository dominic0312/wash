class AddLabelToOrderItem < ActiveRecord::Migration
  def change
    add_column :order_items, :label, :string, :default => nil
  end
end
