class AddProviderIdToProduct < ActiveRecord::Migration
  def change
    add_column :products, :provider_id, :integer, :default => 0
  end
end
