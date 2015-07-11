class AddSourceToUser < ActiveRecord::Migration
  def change
    add_column :users, :source, :string, :default => "self"
  end
end
