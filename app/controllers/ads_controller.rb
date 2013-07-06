class AdsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  respond_to :html, :json

  def index
    @categories = Category.order(:name)
    @regions = Region.order(:name)
    @total_ads_count = Ad.active.count


    @filter = Filter.new(session[:filters].merge(params))
    @ads    = @filter.perform

    session[:filters] = @filter.session

    @selected_category_id = session[:filters]["category_id"]
    @selected_region_id = session[:filters]["region_id"]
    @selected_type = session[:filters]["type"]

    respond_with @ads, :include => [ :city, :category, :region ]
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
