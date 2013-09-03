module Api
  module V1
    class PublicHandler < Sinatra::Base
      get "/categories", provides: :json do
        @categories = Category.all
        rabl :categories, :format => :json
      end

      get "/regions", provides: :json do
        @regions = Region.all
        rabl :regions, :format => :json
      end


      post "/users", provides: :json do
        @user = User.create(params["user"])
        rabl :user, :format => :json
      end
    end
  end
end
