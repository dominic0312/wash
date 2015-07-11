class CreateCartTable < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.timestamps
    end
  end
end
