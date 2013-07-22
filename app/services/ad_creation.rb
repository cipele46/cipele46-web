class AdCreation
  attr_reader :user, :ad

  def initialize(user)
    @user = user
  end

  def create(params)
    @ad = user.ads.new(params)
    @ad.set_status
    if @ad.save
      notify_admin
    end
    @ad
  end

  private

    def notify_admin
      AdminMailer.new_ad(ad).deliver
    end
end
