class AddStatusToAnalyze < ActiveRecord::Migration
  def change
    add_column :analyzes, :processed, :boolean, :default => false
  end
end
