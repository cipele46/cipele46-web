module Api
  module V1
    class ProtectedHandler < Sinatra::Base
      helpers do
        def protect!
          return if authorized?
          headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
          halt 401, "Not authorized\n"
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

      post "/ads", provides: :json do
        protect!
        current_user.ads.create(params[:ad]).to_json
      end

      delete "/ads/:id", provides: :json do
        protect!
        current_user.ads.find(params[:id]).destroy.to_json
      end

      put "/ads/:id", provides: :json do
        protect!
        current_user.ads.find(params[:id]).update_attributes(params["ad"]).to_json
      end

      put "/users/current", provides: :json do
        protect!
        current_user.update_attributes(params["user"]).to_json
      end
    end
  end
end
