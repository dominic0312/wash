class AddStoreageToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :storage, :boolean, :default => false
  end
end
