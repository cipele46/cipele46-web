module Api
  module V1
    class PublicHandler < APIHandler
      get "/categories", provides: :json do
        @categories = Category.all
        rabl :categories, :format => :json
      end

      get "/regions", provides: :json do
        @regions = Region.all
        rabl :regions, :format => :json
      end

      post "/users" do
        @user = User.create!(json_params["user"])
        rabl :user, :format => :json
      end

      post "/ads/:id/reply" do
        @ad = Ad.find(params[:id])
        AdReplying.new.call! email: json_params["email"],
                             content: json_params["content"],
                             ad: @ad
      end
    end
  end
end
