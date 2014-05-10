FactoryGirl.define do
  factory :mac do
    sequence(:mac) do |n|
      last = "#{n}".rjust(2, "0")
      "XX:XX:XX:XX:XX:#{last}"
    end
  end
end
