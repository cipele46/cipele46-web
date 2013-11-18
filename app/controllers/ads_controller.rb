# encoding: utf-8
class AdsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index, :reply]

  respond_to :html, :json

  def index
    @ads_search = @ad_filter.search
    @ads_without_category_id = @ad_filter.search_without(:category_id) 
    @ads_without_ad_type = @ad_filter.search_without(:ad_type) 
    @ads_without_region_id = @ad_filter.search_without(:region_id) 
    @ads_without_user_id = @ad_filter.search_without(:user_id)
    
    # to display breadcrumbs
    @ads_category = Category.find(@ad_filter.category_id) if @ad_filter.category_id != nil
    @ads_region   = Region.find(@ad_filter.region_id) if @ad_filter.region_id != nil
    @ads_type = @ad_filter.ad_type

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
    @ad = AdCreation.new.call :user => current_user, :params => params[:ad]
    respond_with @ad
  end

  def update
    @ad = current_user.ads.find(params[:id])
    @ad.update_attributes(params[:ad])
    respond_with @ad
  end

  def edit
    @ad = current_user.ads.find(params[:id])
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

  def validate_content_and_email content, email
    if !email.present? then
      return "Obavezno je unjeti email za kontakt."
    elsif !email.match /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      return "Email za kontakt je neispravan."
    end
    if !content.present? then
      return "Obavezno je unjeti tekst poruke."
    end
    return nil
  end

  def reply
    ad = Ad.find(params[:ad_id])
    content, email = params[:content], params[:email]

    error = validate_content_and_email content, email
    if error then
      flash[:error] = error
    elsif AdReplying.new.call ad: ad, content: content, email: email
      flash[:notice] = "Sent!"
    else
      flash[:error] = "Could't send you message."
    end

    if flash[:error] then
      redirect_to ad_path(ad, {:email => email, :content => content}), :error => flash[:error]
    else
      redirect_to ad_path(ad, {:email => email, :content => content}), :notice => flash[:notice]
    end
  end

  def toggle
    current_user.toggle_favorite @ad = Ad.find(params[:id])
    respond_with @ad
  end

  def close
    @ad = AdClosure.new.call :user => current_user, :id => params[:ad_id]
    respond_with @ad
  end
end
