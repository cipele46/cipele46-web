module Api
  module V1
    class APIHandler < Sinatra::Base
      configure do
        set :raise_errors, false
        set :show_exceptions, false
      end

      Rabl.register!
      Rabl.configure do |config|
        config.include_json_root = false 
        config.view_paths = ["v1"]
      end

      WELCOME_JSON ||= {
        message: "Welcome to 'Cipele46' JSON API. Find available routes in the 'routes' array.",
        routes: [
          "GET /ads" => "lists all adds",
          "GET /categories" => "lists all categories",
          "GET /regions" => "lists all regions",
          "POST /users" => "creates user",
          "POST /ads" => "creates ad",
          "DELETE /ads/:id" => "deletes ad",
          "PUT /ads/:id" => "updates ad",
          "PUT /ads/:id/toggle_favorite" => "toggles ad as favorite",
          "PUT /users/current" => "updates current user",
          "GET /users/current" => "shows current user",

      ]
      }.to_json

      before do
        content_type :json
        if request.url.match(/.json$/)
          request.accept.unshift('application/json')
          request.path_info = request.path_info.gsub(/.json$/,'')
        end
      end

      error do
        content_type :json

        e = request.env["sinatra.error"]
        {:error => {:message => e.message}}.to_json
      end

      error 401 do
        Response::UNAUTHORIZED
      end

      helpers do
        def json_params
          JSON.parse(request.body.read)
        end
      end
    end
  end
end
