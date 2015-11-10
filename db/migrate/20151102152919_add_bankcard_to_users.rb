class AddBankcardToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bank_card, :string
  end
end
