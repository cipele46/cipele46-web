# encoding: utf-8
#
module AdSteps
  step 'I visit the ad creation page' do
    visit new_ad_path
  end

  step 'I should see a message that I should sign in' do
    page.should have_content("moraš se prijaviti")
  end
end
