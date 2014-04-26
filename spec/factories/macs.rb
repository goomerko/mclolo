FactoryGirl.define do
  factory :mac do
    sequence(:mac){|n| "XXXXXXXXXXXXXXXX#{n}"}
  end
end
