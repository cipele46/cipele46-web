class RegionsController < ApplicationController
  def index
    @regions = Region.find(:all, :include => :cities, :order => :name)
     
    respond_to do |format|
      format.json do 
        render :json => @regions.to_json(:include => :cities, :order => :name)
      end
    end
  end

end
