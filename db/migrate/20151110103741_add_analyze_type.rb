class AddAnalyzeType < ActiveRecord::Migration
  def change
    add_column :analyzes, :anatype, :string
    add_column :analyzes, :year, :string
  end
end
