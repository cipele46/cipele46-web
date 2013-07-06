class AdsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  respond_to :html, :json

  def index
    # imported from home controller
    @demands = Ad.active.demands.count
    @supplies = Ad.active.supplies.count
    @categories = Category.order(:name)
    @regions = Region.order(:name)
    @total_ads_count = Ad.active.count
    # end import

    @ads = Ad.page(params[:page]).per(ADS_PER_PAGE)
    
    if params[:query]
      @ads = @ads.joins(:category).joins(city: [:region]).select("ads.*, categories.name as category, cities.name as city, regions.name as region")
    elsif params[:region_id] 
      @ads = @ads.joins(:city)
    end
    
    @ads = @ads.where(:category_id => params[:category_id]) if params[:category_id]    
    @ads = @ads.where("cities.region_id" => params[:region_id]) if params[:region_id]
    @ads = @ads.where("title like ? OR description like ? OR city like ? or region like ?", params[:query], params[:query], params[:query], params[:query]) if params[:query]
        
    respond_with @ads
  end

  def show
    @ad = Ad.find(params[:id])
  end

  def new
    @ad = current_user.ads.new
  end

  def create
    @ad = AdCreation.new(current_user).create(params[:ad])
    respond_with @ad
  end

  def edit
    @ad = current_user.ads.find(params[:id])
  end

  def update
    @ad = current_user.ads.find(params[:id])
    @ad.update_attributes params[:ad]

    respond_with @ad
  end
end
