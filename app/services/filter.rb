class Filter
  attr_reader :params
  def initialize(params, ads)
    @params = params
    @ads   =  ads
  end

  def perform
    @ads = Ad.active.order("id desc").page(params[:stranica]).per(ADS_PER_PAGE)

    if category = Category.find(params[:category_id]) rescue false
      @ads = category.ads.active.order("id desc").page(params[:stranica]).per(ADS_PER_PAGE)
    end

    if region = Region.find(params[:region_id]) rescue false
      @ads = region.ads.active.order("id desc").page(params[:stranica]).per(ADS_PER_PAGE)
    end

    @ads
  end
end
