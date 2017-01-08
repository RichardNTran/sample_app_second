class AddAdminToUsers < ActiveRecord::Migration[5.0]
  # should user_role instead future--dam solution
  def change
    add_column :users, :admin, :boolean, default: false
  end
end
