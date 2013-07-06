class AdsController < ApplicationController

  def show
    @ad = Ad.find(params[:id])
    
  end

  def new

  end

  def edit

  end
end
