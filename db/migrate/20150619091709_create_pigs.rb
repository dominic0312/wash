class CreatePigs < ActiveRecord::Migration
  def change
    create_table :pigs do |t|
      t.string :name
      t.integer :amount

      t.timestamps null: false
    end
  end
end
