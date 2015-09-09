class AddKindIdToProduct < ActiveRecord::Migration
  def change
    add_column :products, :kind_id, :integer, :default => 0
  end
end
