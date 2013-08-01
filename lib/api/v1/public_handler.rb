module Api
  module V1
    class PublicHandler < Sinatra::Base
      get "/categories", provides: :json do
        Category.all.to_json
      end

      get "/regions", provides: :json do
        Region.all.to_json :include => :cities
      end


      post "/users", provides: :json do
        User.create(params["user"]).to_json
      end
    end
  end
end
