# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    first_name 'Test'
    last_name 'User'
    email { "example#{(1..10).map {rand(10)}.join}@example.com" }
    password 'changeme'
    password_confirmation 'changeme'
    phone '+38519876543'
    # required if the Devise Confirmable module is used
    confirmed_at Time.now
  end
end
