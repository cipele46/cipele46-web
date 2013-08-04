# encoding: utf-8
require "spec_helper"

include AdHelper

def link(text)
  page.find("a", :text => text)
end

feature "Dashboard", :search => true do

  before do
    seed_ads
    visit root_path
  end

  scenario "Ad filtering for giving" do
    filter(:for => :giving).click
    expect_to_see(:giving_only)

    filter(:for => :all).click
    expect_to_see(:all)
  end

  scenario "Ad filtering for receiving" do
    filter(:for => :receiving).click

    expect_to_see(:receiving_only)
  end

  scenario "Ad should have details" do
    filter(:for => :all).click
    find_ad(ad).click

    expect_to_see_details_for ad
  end

  scenario "Ad search" do
    enter_search(:for => ad)
    expect_to_see ad: ad
  end


  scenario "Blog" do
    link("blog").click
    current_path.should eq(blog_index_path)
  end

  scenario "Our story" do
    link("naša priča").click
    current_path.should eq(page_path("nasa-prica"))
  end
end
