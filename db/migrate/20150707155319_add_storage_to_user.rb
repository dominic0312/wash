class AddStorageToUser < ActiveRecord::Migration
  def change
    add_column :users, :storeage, :boolean, :default => false
  end
end
