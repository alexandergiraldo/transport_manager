FactoryBot.define do
  factory :register do
    description { "Test Register" }
    value { 10000 }
    event_date { Date.today }
    register_type { "incoming" }
  end
end