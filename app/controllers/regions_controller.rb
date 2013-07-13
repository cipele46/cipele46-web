class RegionsController < ApplicationController
  respond_to :json

  def index
    @regions = Region.order(:name)
    respond_with @regions, :include => :cities
  end

end
