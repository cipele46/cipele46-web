class AdsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  respond_to :html, :json

  def index
    @demands = Ad.active.demands.count
    @supplies = Ad.active.supplies.count
    @categories = Category.order(:name)
    @regions = Region.order(:name)
    @total_ads_count = Ad.active.count

    @filter = Filter.new(params.merge(session[:filters]), @ads)
    @ads = @filter.perform

    session[:filters] = @filter.session
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
  
  def destroy
    @ad = current_user.ads.find(params[:id])
    @ad.destroy
    
    redirect_to root_url, :notice => "Oglas obrisan"
  end
  
  def dispatch_email
    user_info = params[:user_info]
    ad = Ad.find(params[:id])
    
    if UserMailer.send_email(ad,user_info).deliver
      flash[:notice] = "Sent!"
    else
      flash[:error] = "Could't send you message."
    end
    redirect_to ad_path(ad)
  end
end
