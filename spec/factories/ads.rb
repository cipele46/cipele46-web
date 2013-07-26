# encoding: utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

DESCRIPTION = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt"\
      " ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco"\
      " laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in"\
      " voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat"\
      " non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

TITLES = ["Poklanjam kaput", "Trebalo bi mi 100 kuna", "Tražim plave papuče", "Poklanjam papigu",
   "Trebalo bi mi 200 kuna", "Tražim cipele 47", "Poklanjam commodore 64", "Trebalo bi mi 300 kuna",
   "Tražim zelene papuče", "Poklanjam ženu", "Trebalo bi mi 400 kuna", "Tražim aparat za gašenje požara",
   "Poklanjam babu", "Trebalo bi mi 500 kuna", "Tražim kunu za pivo", "Poklanjam punicu", "Trebalo bi mi 600 kuna",
   "Tražim đemper", "Tražim aparat za gašenje požara", "Poklanjam ćukca", "Trebalo bi mi 600 kuna", "Tražim naočale",
   "Poklanjam kanarinca", "Trebalo bi mi 700 kuna", "Tražim macbook"]

FactoryGirl.define do
  factory :ad do
    title TITLES.sample
    image { File.open("db/seed/adSeedImg#{(1..3).to_a.sample}.jpg") }
    description DESCRIPTION
    ad_type Ad.type.values.sample
    status Ad.status[:active]
    phone "+38591111111"
    email { "email#{(1..10).map { rand(10) }.join}@domena.hr" }
    category
    user
    city
  end
end
