# encoding: utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl
BLOG_DESCRIPTION ||= "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt"\
      " ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco"\
      " laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in"\
      " <h1>voluptate</h1> <h2>velit</h2> <h3>esse</h3> cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat"\
      " non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

BLOG_TITLES ||= ["Cipele našle svog vlasnika", "Caritas nepotreban uz nove super stranice", "Nestašica kratkih majica u Đakovu"]

FactoryGirl.define do
  factory :blog do
    title { BLOG_TITLES.sample }
    content BLOG_DESCRIPTION
    image { File.open("db/seed/adSeedImg#{(1..3).to_a.sample}.jpg") }
  end
end
