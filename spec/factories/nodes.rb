# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :node do
    sequence(:name){|n| "node_#{n}"}

    factory :node_invalid, class: Node do
      name ''
    end
  end
end
