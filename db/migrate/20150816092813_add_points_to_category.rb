class AddPointsToCategory < ActiveRecord::Migration
  def change
    add_column :users, :pointa, :integer, :default => 0
    add_column :users, :pointb, :integer, :default => 0
    add_column :users, :pointc, :integer, :default => 0
    add_column :users, :pointd, :integer, :default => 0
  end
end
