class RemoveAdminFieldsFromUsersAndAddRole < ActiveRecord::Migration[5.2]
  def up
    remove_column(:users, :is_super_admin)
    remove_column(:users, :is_account_admin)
    add_column(:users, :role, :integer, default: 0)
  end

  def dow
    add_column(:users, :is_super_admin, :boolean)
    add_column(:users, :is_account_admin, :boolean)
    remove_column(:users, :role)
  end
end
