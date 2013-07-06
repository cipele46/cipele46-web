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

  def ads_in_category(category)
    Ad.active.where(category_id: category.id).count
  end

  def ads_in_region(region)
    cities = region.cities.map{ |c| c.id }
    Ad.active.where(city_id: cities).count
  end

end
