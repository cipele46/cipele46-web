# encoding: utf-8
require "spec_helper"

def seed_ads
  [[:demand, "I need some nutella here!"],[:supply, "I'm giving away honey"]].each do |type, description|
    create(:ad, ad_type: Ad.type[type], title: "#{description}")
  end
end

def giving_ad; @giving_ad ||= Ad.giving.first; end
def receiving_ad; @receiving_ad ||= Ad.receiving.first; end
def ad; @ad ||= Ad.all.sample; end

feature "Dashboard" do

    before do
      seed_ads
      visit root_path
    end

    scenario "Ad filtering for giving", :search => true do
      page.find("li.giving a").click

      page.should have_selector(".cards-board article.card", count: Ad.giving.count)
      page.should have_content giving_ad.title
      page.should_not have_content receiving_ad.title

      page.find("li.all a").click
      page.should have_selector(".cards-board article.card", count: Ad.count)
      Ad.all.map do |ad|
        page.should have_content(ad.title)
      end
    end

    scenario "Ad filtering for receiving", :search => true do
      page.find("li.receiving a").click

      page.should have_selector(".cards-board article.card", count: Ad.receiving.count)
      page.should have_content receiving_ad.title
      page.should_not have_content giving_ad.title
    end

    scenario "Ad should have details", :search => true do

      page.find("li.all a").click
      page.find("a", :text => ad.title).click

      [ad.phone, time_ago_in_words(ad.expires_at), ad.description,
       ad.title, ad.category.name, ad.region.name].each do |element|
        page.should have_content(element)
      end
    end

    scenario "Ad search", :search => true do

      query = ad.title.split(" ").sample
      page.fill_in("query", :with => query)
      page.click_on("search-button")

      page.should have_selector(".cards-board article.card", count: 1)
      page.should have_content(ad.title)
    end

     scenario "Blog" do
       page.find("a", :text => "blog").click
       page.current_path.should == blog_index_path
     end

    scenario "Our story" do
      page.find("a", :text => "naša priča").click
      page.current_path.should == page_path("nasa-prica")
    end
end
