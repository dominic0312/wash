class AddPriceToProduct < ActiveRecord::Migration
  def change
    add_column :products, :price, :decimal,  :default => 0
  end
end
