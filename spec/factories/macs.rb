FactoryGirl.define do
  factory :mac do
    sequence(:mac){|n| "XX:XX:XX:XX:XX:X#{n}"}
  end
end
