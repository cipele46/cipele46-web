module AdsHelper

  def is_own_ad ad
    return true == (current_user && ad.user && ad.user.id == current_user.id)
  end
end
