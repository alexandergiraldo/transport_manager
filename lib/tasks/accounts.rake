
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
end