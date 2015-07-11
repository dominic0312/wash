class ChangeStorageToUser < ActiveRecord::Migration
  def change
    remove_column :users, :storeage
    add_column :users, :storage, :string, :default => "empty"
 end
end
