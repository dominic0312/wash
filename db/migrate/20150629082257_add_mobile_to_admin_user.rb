class AddMobileToAdminUser < ActiveRecord::Migration
  def change
    add_column :admin_users, :mobile, :string
  end
end
