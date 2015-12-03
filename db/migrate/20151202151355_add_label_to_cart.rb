class AddLabelToCart < ActiveRecord::Migration
  def change
    add_column :cart_items, :label, :string, :default => nil
  end
end
