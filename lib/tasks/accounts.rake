
namespace :accounts do
  desc "Create many to many relationships between accounts and users"
  task create_account_users: :environment do
    User.all.each do |user|
      AccountUser.create!(account_id: user.account_id, user_id: user.id)
    end
  end

  task add_account_to_documents: :environment do
    Document.all.each do |doc|
      doc.update(account_id: doc.user.account_id)
    end
  end

  task group_maintenance_types: :environment do
    # group all maintenance_types by name
    maintenance_types =  Account.find(ENV['ID'].to_i).maintenance_types.pluck(:name, :id)
    # create a list grouped by name
    grouped_maintenance_types = maintenance_types.group_by { |name, id| name.downcase }
    # select keys with more than one value
    types = grouped_maintenance_types.select { |name, id| id.length > 1 }
    list_to_delete = []
    types.each do |name, group|
      full_types = group.select{ |type| Maintenance.where(maintenance_type_id: type[1]).size > 0}

      ids = full_types.map(&:last)
      id = ids.first
      ids.each do |i|
        Maintenance.where(maintenance_type_id: i).update_all(maintenance_type_id: id)
      end

      empty_types = group.select{ |type| Maintenance.where(maintenance_type_id: type[1]).size == 0}
      empty_types.each do |type|
        list_to_delete << type[1]
      end

    end
    MaintenanceType.where(id: list_to_delete).destroy_all
  end
end