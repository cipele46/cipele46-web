module ForSelectHelper

  def ad_types_for_select
    @ad_types_for_select ||= Ad::TYPES
  end

  def categories_for_select
    @categories_for_select ||= Category.all.map { |c| [c.name, c.id] }
  end

  def cities_for_select
    @cities_for_select ||= City.all.map { |c| [c.name, c.id] }
  end

end