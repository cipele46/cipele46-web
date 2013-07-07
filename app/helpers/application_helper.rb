module ApplicationHelper

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def ads_count
    @ads.count
  end

  def total_ads_count
    Ad.active.count
  end

  def supplies_count
    Ad.active.supplies.count
  end

  def demands_count
    Ad.active.demands.count
  end

  def ads_in_category_count(category)
    @ads.where(category_id: category.id).count
  end

  def ads_in_region_count(region)
    cities = region.cities.map{ |c| c.id }
    @ads.where(city_id: cities).count
  end

  def ads_in_region_and_category_count(region, category)
    cities = region.cities.map{ |c| c.id }
    @ads.where(city_id: cities).where(category_id: category.id)
  end

  def ads_plural(ads_count)
    ads_count = ads_count.to_s
    if ads_count[ads_count.size-1,ads_count.size] == '1' && ads_count[ads_count.size-2,ads_count.size] != '11'  && ads_count[ads_count.size-2,ads_count.size] != '111'  && ads_count[ads_count.size-2,ads_count.size] != '1111' && ads_count[ads_count.size-2,ads_count.size] != '11111'
      'oglas'
    else
      'oglasa'
    end
  end

  def ad_is_favorite(ad_id)
    Favorite.where("user_id = ? AND ad_id = ?", current_user.id, ad_id).count > 0 ? true : false
  end

  def ad_type_decode(ad_type)
    # TYPES = { :supply => 1, :demand => 2 }
    case ad_type
    when 1
      'supply'
    when 2
      'demand'
    else
      ''
    end
  end

end
