require "ostruct"

class Filter
  attr_accessor :params

  def initialize(params)
    @params = OpenStruct.new(params.symbolize_keys)
  end

  def perform
    ads = Ad.active

    unless no_filters?
      ads = ads.by_type(params.type)              if params.type
      ads = ads.by_region(params.region_id)       if params.region_id && params.region_id.to_i > 0
      ads = ads.by_category(params.category_id)   if params.category_id && params.category_id.to_i > 0
    end

    if q = params.delete_field(:q) rescue false
      ads = ads.by_query(q) 
    end

    ads.order("id desc").page(params.page).per(ADS_PER_PAGE)
  end

  def no_filters?
    params.type =~ /all/
  end

  def session
    if no_filters?
      {}
    else
      self.params.marshal_dump || {}
    end
  end
end
