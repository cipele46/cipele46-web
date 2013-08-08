class AdClosure
  def call(args = {})
    id, user = args[:id], args[:user]

    (ad = user.ads.find(id)).close!
    ad
  end
end
