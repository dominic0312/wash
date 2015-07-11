class ChangeDefaultUserLevel < ActiveRecord::Migration
  def change
    change_column :users, :level, :string, :default => "注册用户"
  end
end
