FactoryGirl.define do
  factory :mac do
    sequence(:mac) do |n|
      Faker::Internet.mac_address
    end
  end
end
