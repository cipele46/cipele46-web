class Filter
  def initialize(params, ads)
    @params = params
    @ads   =  ads
  end

  def perform
    @ads = Ad.active

    @ads = @ads.by_type(params[:type])            if params[:type]
    @ads = @ads.by_region(params[:region_id])     if params[:region_id]
    @ads = @ads.by_category(params[:category_id]) if params[:category_id]

    @ads.order("id desc").page(params[:stranica]).per(ADS_PER_PAGE)
  end

  def session
    hash = {}
    hash[:category_id] = params[:category_id] if params[:category_id]
    hash[:region_id]   = params[:region_id] if params[:region_id]
    hash
  end

  private

    attr_reader :params
end
