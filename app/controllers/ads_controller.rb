class AdsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  respond_to :html, :json

  def index
    @ads_search = Ad.search(@ad_filter, params[:page], params[:per_page])
    @ads_without_category_id = Ad.search(@ad_filter.clone_without(:category_id), 1, 10000)
    @ads_without_ad_type = Ad.search(@ad_filter.clone_without(:ad_type), 1, 10000)
    @ads_without_region_id = Ad.search(@ad_filter.clone_without(:region_id), 1, 10000)
    respond_with @ads = @ads_search.results
  end

  def show
    @ad = Ad.find(params[:id])
    respond_with @ad
  end

  def new
    @ad = current_user.ads.new
  end

  def create
    @ad = AdCreation.new(current_user).create(params[:oglas] || params[:ad])
    respond_with @ad
  end

  def update
    @ad = current_user.ads.find(params[:id])
    @ad.update_attributes(params[:oglas] || params[:ad])
    respond_with @ad
  end

  def destroy
    @ad = current_user.ads.find(params[:id])
    @ad.destroy
    respond_to do |format|
      format.html { redirect_to root_url, :notice => "Oglas obrisan" }
      format.json { render :nothing => true }
    end
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
