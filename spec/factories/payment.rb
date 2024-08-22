FactoryBot.define do
  factory :payment do
    payment_date { Date.today }
    amount { 100 }
    payment_method { 0 }
  end
end
