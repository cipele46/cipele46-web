# encoding: utf-8

include AuthenticationSteps
include SessionSteps

feature "Authentication" do
  scenario "Facebook sign in", :sunspot_matchers => true do
    visit sign_in_path
  end
end
