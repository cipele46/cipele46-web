class AdminMailer < ActionMailer::Base
  default from: "from@example.com", to: "admin@cipele46.org"

  def new_ad(ad)
    @ad = ad
    mail :subject => "[cipele46] Novi oglas"
  end
end
