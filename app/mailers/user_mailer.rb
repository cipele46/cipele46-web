class UserMailer < ActionMailer::Base
  default from: "no-reply@cipele46.org"
  
  headers = {'Return-Path' => 'no-reply@cipele46.org'}
  
  def send_email(ad, content, email)
    @ad, @content, @email = ad, content, email

    mail(
      to: ad.user.email,
      subject: "Cipele46: Novi odgovor na oglas '#{ad.title}'",
      reply_to: email
    )
  end
end
