class AddAgentLevelToUser < ActiveRecord::Migration
  def change
    add_column :users, :agent_level, :integer
  end
end
