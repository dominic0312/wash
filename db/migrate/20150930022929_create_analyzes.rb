class CreateAnalyzes < ActiveRecord::Migration
  def change
    create_table :analyzes do |t|
      t.integer :user_id
      t.string :mon
      t.integer :pointa
      t.integer :pointb
      t.integer :pointc
      t.integer :pointd

      t.timestamps null: false
    end
  end
end
