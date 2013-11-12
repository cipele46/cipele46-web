# Read about factories at https://github.com/thoughtbot/factory_girl
#
REGIONS = %w.Bjelovarsko-Bilogorska Krapinsko-Zagorska Primorsko-Goranska.

FactoryGirl.define do
  factory :region do
    name { REGIONS.sample }
  end
end
