module Extensions
  module User
    module Social
      def find_for_facebook_oauth(auth, user)
        user = self.find_by_uid_and_provider(auth[:uid], :facebook)
        unless user
          pwd = Devise.friendly_token[0..7]
          user = self.new
          user.provider = 'facebook'
          user.uid = auth[:uid]
          user.email = auth[:info][:email]
          user.first_name = auth[:info][:first_name]
          user.last_name = auth[:info][:last_name]
          user.password = pwd
          user.password_confirmation = pwd
          user.skip_confirmation!
          user.save
        end
        user
      end
    end
  end
end
