class AdsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  respond_to :html, :json

  def show

  end

  def new
    @ad = current_user.ads.new
  end

  def create
    @ad = current_user.ads.new(params[:ad])
    @ad.save

    respond_with @ad
  end

  def edit

  end
end
