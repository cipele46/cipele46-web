module Api
  module V1
    class PublicHandler < Sinatra::Base
      get "/categories", provides: :json do
        Category.all.to_json
      end

      get "/regions", provides: :json do
        Region.all.to_json :include => :cities
      end

      get "/ads", provides: :json do
        AdFilter.new(params).search.results.to_json
      end

      post "/users", provides: :json do
        User.create(params["user"]).to_json
      end
    end
  end
end
