FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "test#{n}@example.com"
    end
    full_name { "Test User" }
    password { "password" }

    factory :account_admin do
      role { 1 }

      after(:create) do |user|
        account = create(:account)
        user.accounts << account
        user.account_id = account.id
      end
    end
  end
end