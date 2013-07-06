class AdsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  respond_to :html, :json

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
