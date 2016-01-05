class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.string :sn
      t.integer :amount
      t.boolean :finished, :default => false

      t.timestamps null: false
    end
  end
end
