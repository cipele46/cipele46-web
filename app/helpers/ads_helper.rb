module AdsHelper
  %w(region_id category_id ad_type user_id).each do |param|
    define_method("selected_#{param}") { params[param].to_i }
  end

  def image_tag_for_ad(ad, options = {})
    version = options[:version] || 'medium'
    image_tag ad.image_url, options.merge(:class => "")
  end
end
