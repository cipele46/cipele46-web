module AuthenticationSteps
  def default_user_attributes
    {:first_name => "Mickey", :last_name => "Mouse", :email => "mickey@disney.com", :password => "password",
      :password_confirmation => "password", :phone => "+38592222222"}
  end

  def fill_in_user_details(attributes = default_user_attributes)
    fill_in "user_first_name", with: attributes[:first_name] if attributes[:first_name]
    fill_in "user_last_name", with: attributes[:last_name] if attributes[:last_name]
    fill_in "user_password", with: attributes[:password] if attributes[:password]
    fill_in "user_password_confirmation", with: attributes[:password_confirmation] if attributes[:password_confirmation]
    fill_in "user_current_password", with: attributes[:current_password] if attributes[:current_password]
    fill_in "user_phone", with: attributes[:phone] if attributes[:phone]
    fill_in "user_email", with: attributes[:email] if attributes[:email]
  end

  def submit_user
    find("input.btn").click
  end

  def should_be_required_for_user(field)
    fill_in_user_details(default_user_attributes.merge({field => ""}))

    submit_user

    within(:css, "div.user_#{field}") do
      page.should(have_css("label.error"))
    end
  end

  def should_be_equal_for_user(field1, field2)
    fill_in_user_details(default_user_attributes.merge({field1 => "b", field2 => "a"}))

    submit_user

    within(:css, "div.user_#{field1}") do
      page.should(have_css("label.error"))
    end
  end
end
