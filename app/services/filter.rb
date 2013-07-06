class Filter
  def initialize(params, ads)
    @params = params.symbolize_keys
    @ads   =  ads
  end

  def perform
    @ads = Ad.active

    type = params[:type]
    @ads = @ads.by_type(type)            if (type and type.to_i > 0)

    region_id = params[:region_id]
    @ads = @ads.by_region(region_id)     if (region_id and region_id.to_i > 0)

    category_id = params[:category_id]
    @ads = @ads.by_category(category_id) if (category_id and category_id.to_i > 0)

    @ads.order("id desc").page(params[:stranica]).per(ADS_PER_PAGE)
  end

  private

    attr_reader :params
end
