class AddStorageToProducts < ActiveRecord::Migration
  def change
    add_column :products, :storage, :boolean, :default => false
  end
end
