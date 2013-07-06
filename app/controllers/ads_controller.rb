class AdsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]

  def show

  end

  def new
    @ad = current_user.ads.new
  end

  def edit

  end
end
