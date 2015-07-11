class AddLevelToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :level, :string
    add_column :categories, :discount, :integer
  end
end
