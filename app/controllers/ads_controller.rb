class AdsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  respond_to :html, :json

  def index

    respond_to do |format|
      format.html {
        @categories = Category.order(:name)
        @regions = Region.order(:name)
        @total_ads_count = Ad.active.count

        @filter = Filter.new(session[:filters].merge(params))
        @ads    = @filter.perform

        session[:filters] = @filter.session

        @selected_category_id = session[:filters][:category_id]
        @selected_region_id   = session[:filters][:region_id]
        @selected_type        = session[:filters][:type]

        respond_with @ads, :include => [ :city, :category, :region ]        
      }
      format.json { 
        ads = Ad.active
        ads = ads.by_type(params[:type])              if params[:type]
        ads = ads.by_region(params[:region_id])       if params[:region_id]
        ads = ads.by_category(params[:category_id])   if params[:category_id]
        ads = ads.by_query(params[:query])            if params[:query]
        ads = ads.where(:ad_type => params[:ad_type]) if params[:ad_type]
        ads = ads.where(:status => params[:status])   if params[:status]
        if params[:user] || params[:favorites]
          authenticate_user!
          ads = ads.where(:user_id => current_user.id)  if params[:user]
          ads = ads.by_user_favorites(current_user.id)  if params[:favorites]
        end
        ads = ads.order("id desc")
        ads = ads.page(params[:page] || 1).per(params[:per_page])
        
        render json: ads, :include => [ :city, :category, :region ]
      }
    end
    
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
