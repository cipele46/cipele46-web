module SessionSteps
  def sign_up_with(email, password)
    visit sign_up_path
    fill_in 'email', with: email
    fill_in 'password', with: password
    click_button 'Sign up'
  end

  def sign_in(user = create(:user))
    visit sign_in_path
    fill_in 'E-mail', with: user.email
    fill_in 'Lozinka', with: user.password
    click_button 'Prijavi se'
    user
  end

  def sign_out
    find("#sign-out").click
  end

  private

    def sign_in_path
      new_user_session_path
    end

    def sign_up_path
      new_user_registration_path
    end
end
