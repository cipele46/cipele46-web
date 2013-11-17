  class RegistrationsController < Devise::RegistrationsController
    def create
      if verify_recaptcha
        super
      else
        build_resource params["user"]
        clean_up_passwords(resource)
        flash.now[:alert] = "Niste ispravno unjeli recaptcha kod. Molimo, unesite ga ponovo."      
        flash.delete :recaptcha_error
        render :new
      end
    end
  end