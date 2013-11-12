# encoding: utf-8
require "spec_helper"

include DashboardSteps

feature "Dashboard", :search => true do
  before do
    seed_ads
    visit root_path
  end

  scenario "Ad filtering for giving" do
    filter(:for => :giving).click
    expect_to_see Ad.giving
    expect_not_to_see Ad.receiving

    filter(:for => :all).click
    expect_to_see Ad.all
  end

  scenario "Ad filtering for receiving" do
    filter(:for => :receiving).click

    expect_to_see Ad.receiving
    expect_not_to_see Ad.giving
  end

  scenario "Ad should have details" do
    filter(:for => :all).click
    find_ad(ad).click

    expect_to_see_details_for ad
  end

  scenario "Ad search" do
    enter_search(:for => ad)
    expect_to_see ad
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
