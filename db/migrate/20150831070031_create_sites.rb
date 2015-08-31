class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :account1
      t.string :account2
      t.string :alipay

      t.timestamps null: false
    end
  end
end
