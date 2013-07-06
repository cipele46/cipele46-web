module AdsHelper

  def is_own_ad ad
    return true == (current_user && ad.user && ad.user.id == current_user.id)
  end

  def image_tag_for_ad(ad, options = {})
    version = options[:version] || 'medium'
    src = ad.image_url || image_path("ad/placeholder/#{version}.png")
    image_tag src, options
  end
end
