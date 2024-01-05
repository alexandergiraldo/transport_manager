
namespace :settings do
  desc "Create global settings"
  task create_global_settings: :environment do
    Account.all.each do |account|
      GlobalSetting.create!(day_fee: 184000, account: account)
    end
  end
end
