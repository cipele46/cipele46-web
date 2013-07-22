module ForSelectHelper

  def ad_types_for_select
    @ad_types_for_select ||= Ad.type
  end

  def categories_for_select
    @categories_for_select ||= Category.all.map { |c| [c.name, c.id] }
  end

  def cities_for_select
    @cities_for_select ||= load_cities_for_select
  end

  private

  def load_cities_for_select
    Region.order(:name).includes(:cities).map do |region|
      cities = region.cities.map { |c| [c.name, c.id] }
      [region.name, cities]
    end
  end

end
