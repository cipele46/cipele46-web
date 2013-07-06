# -*- encoding : utf-8 -*-
class SocialController < ApplicationController

  # def twitter
  #   if existing_twitter_user
 #      sign_in :user, existing_twitter_user
 #      redirect_to :back
 #    else
 #      user = User.new
 #      user.twitter_id = auth_hash.uid
 #      user.email = auth_hash.uid + "@twitter.com"
 #      user.first_name = auth_hash.info.name
 #      user.confirmed_at = DateTime.now
 #      user.save
 #      sign_in :user, user
 #      redirect_to root_url
 #    end
  # end

  def facebook
    if existing_facebook_user
      sign_in :user, existing_facebook_user
      redirect_to :back
    else
      duplicate = User.find_by_email(auth_hash.info.email)
      if duplicate
        redirect_to social_failure_path + "?message=Korisnik sa adresom #{auth_hash.info.email} je već registriran!"
      else
        user = User.new
        user.facebook_uid = auth_hash.uid
        user.first_name = auth_hash.info.name
        user.email = auth_hash.info.email
        user.confirmed_at = DateTime.now
        user.save
        sign_in :user, user
        redirect_to root_url
      end
    end
  end

  # def linkedin
  #   if existing_linkedin_user
  #     sign_in :user, existing_linkedin_user
  #     redirect_to :back
  #   else
  #     user = User.new
  #     user.linkedin_id = auth_hash.uid
  #     user.email = auth_hash.info.email
  #     user.first_name = auth_hash.info.name
  #     user.nick = auth_hash.info.nickname
  #     user.confirmed_at = DateTime.now
  #     user.save
  #     sign_in :user, user
  #     redirect_to root_url
  #   end
  #   #render text: auth_hash.inspect
  # end

  # def google
  #   if existing_google_user
  #     sign_in :user, existing_google_user
  #     redirect_to :back
  #   else
  #     user = User.new
  #     user.google_id = auth_hash.uid
  #     user.email = auth_hash.info.email
  #     user.first_name = auth_hash.info.name
  #     user.confirmed_at = DateTime.now
  #     user.save
  #     sign_in :user, user
  #     redirect_to root_url
  #   end
  #   #render text: auth_hash.inspect
  # end

  def failure
    render :text => "Error: " + params[:message]
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

  #def existing_twitter_user
  #  User.find_by_twitter_id(auth_hash.uid)
  #end

  def existing_facebook_user
    User.find_by_facebook_uid(auth_hash.uid)
  end

  #def existing_google_user
  #  User.find_by_google_id(auth_hash.uid)
  #end

  #def existing_linkedin_user
  #  User.find_by_linkedin_id(auth_hash.uid)
  #end


end
