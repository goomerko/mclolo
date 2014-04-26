# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user, class: User do
    sequence(:email){|n| "user_#{n}@email.com"}
    password 'monkeymonkey'

    factory :admin_user do
      admin true
    end
  end
end
