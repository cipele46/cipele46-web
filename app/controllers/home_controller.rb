class HomeController < ApplicationController

  def index
    @demands = Ad.active.demands.count
    @offers = Ad.active.offers.count
    @categories = Category.order(:name)
    @regions = Region.order(:name)
  end
end
