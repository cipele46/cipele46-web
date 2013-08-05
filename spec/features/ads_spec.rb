# encoding: utf-8

include AdHelper
include SessionHelper

def debug
  save_and_open_page
end

feature "Ads" do
  scenario "Ad creation for guests" do
    visit new_ad_path
    expect_to_see("moraš se prijaviti")
  end

  scenario "Ad creation for users", :sunspot_matchers => true do
    ["Clothing", "Food"].each {|name| create(:category, :name => name) }
    ["Zagreb", "Split"].each {|name| create(:city, :name => name) }

    sign_in
    visit new_ad_path

    fill_in_ad_details

    submit_ad

    expect_to_see_details_for Ad.last
  end

  scenario "Ad validations", :sunspot_matchers => true do
    ["Clothing", "Food"].each {|name| create(:category, :name => name) }
    ["Zagreb", "Split"].each {|name| create(:city, :name => name) }

    sign_in
    visit new_ad_path

    should_be_required :ad_type
    should_be_required :title
    should_be_required :description
    should_be_required :phone

    should_not_be_required :email
  end
end
