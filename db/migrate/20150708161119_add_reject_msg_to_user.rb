class AddRejectMsgToUser < ActiveRecord::Migration
  def change
    add_column :users, :reject_msg, :string, :default => "无"
  end
end
