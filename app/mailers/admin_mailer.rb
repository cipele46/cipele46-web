class AdminMailer < ActionMailer::Base
  default from: "from@example.com", to: "vladocingel@gmail.com"

  def new_ad(ad)
    @ad = ad
    mail :subject => "[cipele46] Novi oglas"
  end
end
