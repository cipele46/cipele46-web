module Api
  module V1
    class ProtectedHandler < APIHandler
      helpers do
        def protect!
          return if authorized?
          headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
          halt 401
        end

        def authorized?
          @auth = Rack::Auth::Basic::Request.new(request.env)
          @auth.provided? and @auth.basic? and current_user.valid_password?(@auth.credentials.last)
        rescue 
          false
        end

        def current_user
          @user ||= User.find_by_email(@auth.credentials.first)
        end
      end

      get "/ads", provides: :json do
        protect! if params["user"] || params["favorites"]
        params["user"] = current_user if params["user"]

        @ads = case
        when params["favorites"]
          current_user.favorite_ads.search(params)
        else
          Ad.search(params)
        end
        rabl :ads, :format => :json
      end

      post "/ads", provides: :json do
        protect!
        @ad = current_user.ads.create!(params[:ad])
        rabl :ad, :format => :json
      end

      delete "/ads/:id", provides: :json do
        protect!
        @ad = current_user.ads.find(params[:id]).destroy
        rabl :ad, :format => :json
      end

      put "/ads/:id", provides: :json do
        protect!
        @ad = current_user.ads.find(params[:id])
        @ad.update_attributes!(params["ad"])
        rabl :ad, :format => :json
      end

      put "/ads/:id/toggle_favorite", provides: :json do
        protect!
        @ad = current_user.toggle_favorite(Ad.find(params[:id]))
        rabl :ad, :format => :json
      end

      put "/users/current", provides: :json do
        protect!
        current_user.update_attributes!(params["user"])
        @user = current_user
        rabl :user, :format => :json
      end

      get "/users/current", provides: :json do
        protect!
        @user = current_user
        rabl :user, :format => :json
      end
    end
  end
end
