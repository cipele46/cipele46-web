# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    name { %w(Clothing Food Electronics Jobs).sample }
  end
end
