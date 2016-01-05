class AddTypeToCharge < ActiveRecord::Migration
  def change
    add_column :charges, :chr_type, :string, :default => "充值"
  end
end
