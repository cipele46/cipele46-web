# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ad do
    title "MyString"
    image_url "MyString"
    description ""
    category nil
    user nil
    type 1
    status 1
    city nil
  end
end
