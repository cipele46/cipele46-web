# encoding: utf-8
feature "Ads" do
  scenario "Ad creation for guests" do
    visit new_ad_path
    page.should have_content("moraš se prijaviti")
  end
end
