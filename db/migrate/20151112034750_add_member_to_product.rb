class AddMemberToProduct < ActiveRecord::Migration
  def change
    add_column :products, :is_member, :boolean, :default => false
  end
end
