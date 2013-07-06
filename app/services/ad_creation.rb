class AdCreation
  attr_reader :user, :ad

  def initialize(user)
    @user = user
  end

  def create(params)
    @ad = user.ads.new(params)
    @ad.set_status
    @ad.save
  end

end