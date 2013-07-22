# encoding: UTF-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) are set in the file config/application.yml.
# See http://railsapps.github.io/rails-environment-variables.html
YAML.load(ENV['ROLES']).each do |role|
  Role.find_or_create_by_name({ :name => role }, :without_protection => true)
  puts 'role: ' << role
end

user = User.find_or_create_by_email :first_name => ENV['ADMIN_NAME'].dup, :email => ENV['ADMIN_EMAIL'].dup, :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup, :phone => '0989814972'
puts 'user: ' << user.name
user.confirm!
user.add_role :admin

{
 'Bjelovarsko-bilogorska'           => ['Bjelovar', 'Čazma', 'Daruvar', 'Garešnica', 'Grubišno Polje'],
 'Brodsko-posavska'                 => ['Nova Gradiška', 'Slavonski Brod'],
 'Dubrovačko-neretvanska'           => ['Dubrovnik', 'Korčula', 'Metković', 'Opuzen', 'Ploče'],
 'Istarska'                         => ['Pula', 'Pazin', 'Poreč', 'Buje', 'Buzet', 'Labin', 'Novigrad', 'Rovinj', 'Umag', 'Vodnjan'],
 'Karlovačka'                       => ['Duga Resa', 'Karlovac', 'Ogulin', 'Slunj', 'Ozalj'],
 'Koprivničko-križevačka'           => ['Đurđevac', 'Koprivnica', 'Križevci'],
 'Krapinsko-zagorska'               => ['Donja Stubica', 'Klanjec', 'Krapina', 'Oroslavje', 'Pregrada', 'Zabok', 'Zlatar'],
 'Ličko-senjska'                    => ['Gospić', 'Otočac', 'Brinje', 'Senj', 'Karlobag'],
 'Međimurska'                       => ['Čakovec', 'Mursko Središće', 'Prelog'],
 'Osječko-baranjska'                => ['Beli Manastir', 'Belišće', 'Donji Miholjac', 'Đakovo', 'Našice', 'Osijek', 'Valpovo'],
 'Požeško-slavonska'                => ['Kutjevo', 'Lipik', 'Pakrac', 'Pleternica', 'Požega'],
 'Primorsko-goranska'               => ['Rijeka', 'Bakar', 'Cres', 'Crikvenica', 'Čabar', 'Delnice', 'Kastav', 'Kraljevica', 'Krk', 'Mali Lošinj', 'Novi Vinodolski', 'Opatija', 'Rab', 'Vrbovsko'],
 'Sisačko-moslavačka'               => ['Glina', 'Hrvatska Kostajnica', 'Kutina', 'Novska', 'Sisak', 'Petrinja'],
 'Splitsko-dalmatinska'             => ['Hvar', 'Imotski', 'Kaštela', 'Komiža', 'Makarska', 'Omiš', 'Sinj', 'Solin', 'Split', 'Stari Grad', 'Supetar', 'Trilj', 'Trogir', 'Vis', 'Vrgorac', 'Vrlika'],
 'Varaždinska'                      => ['Ivanec', 'Lepoglava', 'Ludbreg', 'Novi Marof', 'Varaždin', 'Varaždinske Toplice'],
 'Virovitičko-podravska'            => ['Orahovica', 'Slatina', 'Virovitica'],
 'Vukovarsko-srijemska'             => ['Vukovar', 'Vinkovci', 'Ilok', 'Županja'],
 'Zadarska'                         => ['Zadar', 'Benkovac', 'Biograd na Moru', 'Nin', 'Obrovac', 'Pag'],
 'Zagrebačka'                       => ['Dugo Selo', 'Ivanić Grad', 'Jastrebarsko', 'Samobor', 'Sveti Ivan Zelina', 'Velika Gorica', 'Vrbovec', 'Zaprešić'],
 'Šibensko-kninska'                 => ['Drniš', 'Knin', 'Skradin', 'Šibenik', 'Vodice'],
 'Grad Zagreb'                      => ['Zagreb']
}.each_pair do |region, cities|

  r = Region.find_by_name region
  unless r
    r = Region.create(:name => region)
    cities.each do |city|
      r.cities.create(:name => city)
    end
  end

end


[
  "Hrana",
  "Zdravlje i higijena",
  "Odjeća i obuća",
  "Elektronika",
  "Sve za djecu",
  "Namještaj",
  "Kućanski aparati",
  "Kućanske potrepštine",
  "Poslovi i usluge",
  "Hobi i zabava",
  "Ostalo"
].each do |categoryName|

  category = Category.find_by_name categoryName
  unless category
    category = Category.create(:name => categoryName)
  end

end

placeholderAdDescription =
"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt"\
" ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco"\
" laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in"\
" voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat"\
" non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."\

[
  [ "Poklanjam kaput", 1, 1, 1, 'adSeedImg1.jpg', Ad::STATUS[:active], Ad.type[:supply], "091 555 666", "email@domena.hr"],
  [ "Trebalo bi mi 100 kuna", 2, 1, 20, 'adSeedImg2.jpg', Ad::STATUS[:active], Ad.type[:demand], "091 555 666", "email@domena.hr"],
  [ "Tražim plave papuče", 3, 1, 30, 'adSeedImg3.jpg', Ad::STATUS[:active], Ad.type[:demand], "091 555 666", "email@domena.hr"],  
  [ "Poklanjam papigu", 1, 1, 1, 'adSeedImg1.jpg', Ad::STATUS[:active], Ad.type[:supply], "091 555 666", "email@domena.hr"],
  [ "Trebalo bi mi 200 kuna", 2, 1, 20, 'adSeedImg2.jpg', Ad::STATUS[:active], Ad.type[:demand], "091 555 666", "email@domena.hr"],
  [ "Tražim cipele 47", 3, 1, 30, 'adSeedImg3.jpg', Ad::STATUS[:active], Ad.type[:demand], "091 555 666", "email@domena.hr"],
  [ "Poklanjam commodore 64", 1, 1, 1, 'adSeedImg1.jpg', Ad::STATUS[:active], Ad.type[:supply], "091 555 666", "email@domena.hr"],
  [ "Trebalo bi mi 300 kuna", 2, 1, 20, 'adSeedImg2.jpg', Ad::STATUS[:active], Ad.type[:demand], "091 555 666", "email@domena.hr"],
  [ "Tražim zelene papuče", 3, 1, 30, 'adSeedImg3.jpg', Ad::STATUS[:active], Ad.type[:demand], "091 555 666", "email@domena.hr"],
  [ "Poklanjam ženu", 1, 1, 1, 'adSeedImg1.jpg', Ad::STATUS[:active], Ad.type[:supply], "091 555 666", "email@domena.hr"],
  [ "Trebalo bi mi 400 kuna", 2, 1, 20, 'adSeedImg2.jpg', Ad::STATUS[:active], Ad.type[:demand], "091 555 666", "email@domena.hr"],
  [ "Tražim aparat za gašenje požara", 3, 1, 30, 'adSeedImg3.jpg', Ad::STATUS[:active], Ad.type[:demand], "091 555 666", "email@domena.hr"],
  [ "Poklanjam babu", 1, 1, 1, 'adSeedImg1.jpg', Ad::STATUS[:active], Ad.type[:supply], "091 555 666", "email@domena.hr"],
  [ "Trebalo bi mi 500 kuna", 2, 1, 20, 'adSeedImg2.jpg', Ad::STATUS[:active], Ad.type[:demand], "091 555 666", "email@domena.hr"],
  [ "Tražim kunu za pivo", 3, 1, 30, 'adSeedImg3.jpg', Ad::STATUS[:active], Ad.type[:demand], "091 555 666", "email@domena.hr"],
  [ "Poklanjam punicu", 1, 1, 1, 'adSeedImg1.jpg', Ad::STATUS[:active], Ad.type[:supply], "091 555 666", "email@domena.hr"],
  [ "Trebalo bi mi 600 kuna", 2, 1, 20, 'adSeedImg2.jpg', Ad::STATUS[:active], Ad.type[:demand], "091 555 666", "email@domena.hr"],
  [ "Tražim đemper", 3, 1, 30, 'adSeedImg3.jpg', Ad::STATUS[:active], Ad.type[:demand], "091 555 666", "email@domena.hr"],
  [ "Tražim aparat za gašenje požara", 3, 1, 30, 'adSeedImg3.jpg', Ad::STATUS[:active], Ad.type[:demand], "091 555 666", "email@domena.hr"],
  [ "Poklanjam ćukca", 1, 1, 1, 'adSeedImg1.jpg', Ad::STATUS[:active], Ad.type[:supply], "091 555 666", "email@domena.hr"],
  [ "Trebalo bi mi 600 kuna", 2, 1, 20, 'adSeedImg2.jpg', Ad::STATUS[:active], Ad.type[:demand], "091 555 666", "email@domena.hr"],
  [ "Tražim naočale", 3, 1, 30, 'adSeedImg3.jpg', Ad::STATUS[:active], Ad.type[:demand], "091 555 666", "email@domena.hr"],
  [ "Poklanjam kanarinca", 1, 1, 1, 'adSeedImg1.jpg', Ad::STATUS[:active], Ad.type[:supply], "091 555 666", "email@domena.hr"],
  [ "Trebalo bi mi 700 kuna", 2, 1, 20, 'adSeedImg2.jpg', Ad::STATUS[:active], Ad::type[:demand], "091 555 666", "email@domena.hr"],
  [ "Tražim macbook", 3, 1, 30, 'adSeedImg3.jpg', Ad::STATUS[:active], Ad.type[:demand], "091 555 666", "email@domena.hr"]
   
  
].each do |adData|

  ad = Ad.find_by_title adData[0]
  unless ad
    ad = Ad.create(
      :title => adData[0],
      :description => placeholderAdDescription,
      :category_id => adData[1],
      :user_id => adData[2],
      :city_id => adData[3],
      :image => File.open("db/seed/#{adData[4]}"),
      :status => adData[5],
      :ad_type => adData[6],
      :phone => adData[7],
      :email => adData[8]
    )
  end

end

