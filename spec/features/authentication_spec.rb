# encoding: utf-8

include AuthenticationSteps
include SessionSteps

feature "Authentication" do
  scenario "Validations", :sunspot_matchers => true do
    visit new_user_registration_path

    should_be_required_for_user :email
    should_be_required_for_user :password
    should_be_required_for_user :phone

    should_be_equal_for_user :password, :password_confirmation
  end

  scenario "Sign up", :sunspot_matchers => true do
    visit new_user_registration_path

    fill_in_user_details

    expect { submit_user }.to change{ User.count }.by(1)

    expect(current_path).to eq(root_path)
  end

  scenario "Sign in", :sunspot_matchers => true do
    current_user = sign_in

    expect_to_see("Uspješno si se prijavio")

    expect_to_see(current_user.first_name)
    expect_to_see(current_user.last_name)

    expect(current_path).to eq(root_path)
  end

  scenario "Sign out", :sunspot_matchers => true do
    current_user = sign_in

    sign_out

    expect(current_path).to eq(root_path)

    expect_to_see("Uspješno si se odjavio")

    expect_not_to_see current_user.first_name
    expect_not_to_see current_user.last_name
  end

  scenario "Editing details", :sunspot_matchers => true do
    current_user = sign_in

    visit edit_user_registration_path(current_user)

    fill_in_user_details(default_user_attributes.merge(:current_password => current_user.password, :first_name => "Mickey"))
    submit_user

    expect(current_path).to eq(root_path)

    expect_to_see "Mickey"
  end
end
