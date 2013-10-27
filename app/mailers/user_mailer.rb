class UserMailer < ActionMailer::Base
  default from: "no-reply@cipele46.org"
  
  headers = {'Return-Path' => 'no-reply@cipele46.org'}
  
  def send_email(ad, content, email)
    @email, @content = email, content

    mail(
      to: ad.user.email,
      subject: "Cipele46: #{ad.title}",
      reply_to: email
    )
  end
end
