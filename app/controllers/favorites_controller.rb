class FavoritesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def toggle
    ad_id = params[:id].to_i

    unless Ad.exists?(ad_id)
      respond_with "No such ad #{ad_id}", :status => 404
      return
    end

    favorite = Favorite.where("user_id = ? AND ad_id = ?", current_user.id, ad_id)

    unless favorite.empty?
      favorite.first.destroy
    else
      favorite = Favorite.new()
      favorite.user_id = current_user.id
      favorite.ad_id = ad_id
      favorite.save
    end
    
    respond_with favorite
  end
end