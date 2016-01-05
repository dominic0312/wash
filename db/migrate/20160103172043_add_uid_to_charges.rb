class AddUidToCharges < ActiveRecord::Migration
  def change
    add_column :charges, :user_id, :integer, :default => nil
  end
end
