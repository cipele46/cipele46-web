module Api
  module V1
    class PublicHandler < Sinatra::Base
      configure do
        set :raise_errors, false
        set :show_exceptions, false
      end

      error do
        content_type :json

        e = env["sinatra.error"]
        {:error => {:message => e.message}}.to_json
      end

      get "/categories", provides: :json do
        @categories = Category.all
        rabl :categories, :format => :json
      end

      get "/regions", provides: :json do
        @regions = Region.all
        rabl :regions, :format => :json
      end


      post "/users", provides: :json do
        @user = User.create!(params["user"])
        rabl :user, :format => :json
      end
    end
  end
end
