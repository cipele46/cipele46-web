# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :favorite, :class => 'Favorites' do
    ad 
    user 
  end
end
