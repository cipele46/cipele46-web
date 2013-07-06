class UserMailer < ActionMailer::Base
  default from: "no-reply@cipele46.org"
  
  headers = {'Return-Path' => 'no-reply@cipele46.org'}
  
  def send_email(ad,user_info)
    @user_info = user_info

    mail(
      to: ad.user.email,
      subject: "Cipele46: #{ad.title}",
      reply_to: @user_info[:email]
    )
  end
end
