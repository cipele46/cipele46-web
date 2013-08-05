# Read about factories at https://github.com/thoughtbot/factory_girl
#

CITIES = %w.Split Zagreb Bjelovar Osijek Samobor Sisak Kutina.

FactoryGirl.define do
  factory :city do
    name { CITIES.sample }
    region
  end
end
