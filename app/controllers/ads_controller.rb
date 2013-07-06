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

    if category = Category.find(params[:category_id]) rescue false
      @ads = category.ads.active.order("id desc").page(params[:stranica]).per(ADS_PER_PAGE)
    else
      @ads = Ad.active.order("id desc").page(params[:stranica]).per(ADS_PER_PAGE)
    end
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
