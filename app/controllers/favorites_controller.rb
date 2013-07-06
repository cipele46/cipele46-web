class FavoritesController < ApplicationController

def toggle

  if current_user

    ad_id = params[:id].to_i

    favorite = Favorites.where("user_id = ? AND ad_id = ?", current_user.id, ad_id)

    unless favorite.empty?
      favorite.first.destroy
    else
      favorite = Favorites.new()
      favorite.user_id = current_user.id
      favorite.ad_id = ad_id
      favorite.save
    end
  end

end

end