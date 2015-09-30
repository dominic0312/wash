class AddDefaultAgentLevelToUser < ActiveRecord::Migration
  def change
    change_column :users, :agent_level, :integer, :default => 1
  end
end
