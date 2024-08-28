FactoryBot.define do
  factory :accounts_payable do
    name { "Test Accounts Payable" }
    start_date { Date.today }
  end
end
