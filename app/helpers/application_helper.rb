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

  def number_of_ads_in(facet, value = nil)
    instance_variable_get("@ads_without_#{facet}").facet(facet).rows.select{ |row| row.value == value || value == nil }.sum{ |row| row.count } || 0
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
    current_user.favorite_ads.map(&:id).include?(ad_id) ? true : false
  end

  def align_footer
    if current_page?(root_path)
      "align"
    end
  end

  def body_id
    if rendering_ad_form? then "addPage"
    else "page"
    end
  end

  def wrapper_class
    klass = "page-content-wrapper clearfix"
    klass << " inner-page blog giving" if rendering_blog?
    klass << " inner-page" if rendering_ad_form?
    klass
  end

  private

    def rendering_ad_form?
      controller_name == "ads" && ["new","edit","create", "update"].include?(action_name)
    end

    def rendering_blog?
      controller_name == "blog"
    end
end
