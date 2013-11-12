class AdCreation
  attr_reader :user, :ad

  def call(opts = {})
    params, user = opts.fetch(:params), opts.fetch(:user)
    self.ad      = user.ads.new(params)

    ad.set_status
    if ad.save
      notify_admin
    end

    ad
  end

  private

    attr_writer :ad

    def notify_admin
      AdminMailer.new_ad(ad).deliver
    end
end
