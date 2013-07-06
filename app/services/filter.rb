class Filter
  def initialize(params)
    @params = params.symbolize_keys
  end

  def perform
    ads = Ad.active

    type = params[:type]
    ads = ads.by_type(type)            if type && type !~ /all/

    region_id = params[:region_id]
    ads = ads.by_region(region_id)     if (region_id and region_id.to_i > 0)

    category_id = params[:category_id]
    ads = ads.by_category(category_id) if (category_id and category_id.to_i > 0)
    
    ads = ads.by_query(params[:q]) if params[:q]


    ads.order("id desc").page(params[:page]).per(ADS_PER_PAGE)
  end

  private

    attr_reader :params
end
