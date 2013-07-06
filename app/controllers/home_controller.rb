class HomeController < ApplicationController

  #TODO - move to config file
  ADS_PER_PAGE = 1

  def index
    @demands = Ad.active.demands.count
    @offers = Ad.active.offers.count
    @categories = Category.order(:name)
    @regions = Region.order(:name)
    @ads = Ad.active.order("id desc").page(params[:stranica]).per(ADS_PER_PAGE)
  end

end
