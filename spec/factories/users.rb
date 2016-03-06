FactoryGirl.define do
  factory :user do

    trait :broker do
      role :broker
    end

    trait :admin do
      role :admin
    end

    trait :guest do
      role :guest
    end

    sequence(:email) { |n| "user#{n}@example.com" }

    password 'password'
    password_confirmation 'password'
    name 'Example User'

    #Default user role is guest
    guest

    factory :user_admin, traits: [:admin]
    factory :user_broker, traits: [:broker]
  end

end
