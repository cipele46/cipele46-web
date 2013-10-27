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

include SunspotHelper

def log(message)
  print "\n[Seeds] #{message}"
end

def announce_start
  @start = Time.now
  print "=" * 30
  log "started seeding data\n\n"
end

def announce_finish
  puts "=" * 30
  log "Success! :)"
  log "Seeding took #{(Time.now - @start).round(2)} seconds.\n\n"
end

def import_roles
  log "importing roles"
  YAML.load(ENV['ROLES']).each do |role|
    Role.find_or_create_by_name({ :name => role }, :without_protection => true)
    print "."
  end
end

def create_admin
  log "creating admin [username: #{ENV['ADMIN_EMAIL']} password: #{ENV['ADMIN_PASSWORD']}]"
  ActionMailer::Base.delivery_method = :test
  user = User.find_or_create_by_email :first_name => ENV['ADMIN_NAME'].dup, :email => ENV['ADMIN_EMAIL'].dup, :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup
  user.confirm!
  user.add_role :admin
end

# IMPORTANT NOTE: This user is selected as default in active admin when adding new Ad (recognized by first and last name)
# See also app/admin/ads.rb
def create_default_user
  password = SecureRandom.hex(4)
  u = User.new(first_name: 'Cipele', last_name: '46', email: 'contact@cipele46.org', password: password, password_confirmation: password)
  u.confirmed_at = Time.current
  u.save
end

def import_regions
  log "importing regions"
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

    print "."

    r = Region.find_by_name region
    unless r
      r = Region.create(:name => region)
      cities.each do |city|
        r.cities.create(:name => city)
      end
    end
  end
end

def import_categories
  log "importing categories"
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
    print "."
    Category.find_or_create_by_name(:name => categoryName)
  end
end

def import_ads
  log "importing ads"
  20.times do
    print "."
    FactoryGirl.create(:ad, category: Category.all.sample, city: City.all.sample, user: User.all.sample)
  end
end

def import_blogs
  log "importing blogs"
  4.times do
    print "."
    FactoryGirl.create(:blog)
  end
end

announce_start
setup_solr
puts

import_roles
create_default_user
create_admin
import_regions
import_categories
import_ads
import_blogs
puts

announce_finish
