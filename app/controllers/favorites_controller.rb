class FavoritesController < ApplicationController

def toggle
  
  if current_user
    
    adid = params[:id].to_i
    
    favorite = Favorites.where("user_id = ? AND ad_id = ?", current_user.id, adid)
  
    unless favorite.empty?
      favorite.first.destroy
    else
      favorite = Favorites.new(current_user.id, adid)
      favorite.save
    end
  end

end

end