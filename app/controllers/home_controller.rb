class HomeController < ApplicationController

  #TODO - move to config file
  ADS_PER_PAGE = 15

  def index
    @demands = Ad.active.demands.count
    @supplies = Ad.active.supplies.count
    @categories = Category.order(:name)
    @regions = Region.order(:name)
    @ads = Ad.active.order("id desc").page(params[:stranica]).per(ADS_PER_PAGE)
  end

end
