FactoryBot.define do
  factory :vehicle do
    sequence :license_plate do |n|
      "ABC13#{n}"
    end

    factory :taxi do
      model_date { 2018 }
      vehicle_type { 0 }
    end

    factory :truck do
      model_date { 2018 }
      vehicle_type { 1 }
    end
  end
end