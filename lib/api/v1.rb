require_relative("./v1/public_handler")
require_relative("./v1/protected_handler")

require "rabl"
require 'active_support/core_ext'
require 'active_support/inflector'
require 'builder'

module Api 
  module V1
    module Response
     UNAUTHORIZED = {"error" => "Unauthorized"}.to_json
    end

    class Base < Sinatra::Base
      Rabl.register!

      Rabl.configure {|c| c.include_json_root = false }

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
      end

      error do
        {"error" => request.env["sinatra.error"]}.to_json
      end

      before /.*/ do
        if request.url.match(/.json$/)
          request.accept.unshift('application/json')
          request.path_info = request.path_info.gsub(/.json$/,'')
        end
      end

      get "/" do
        WELCOME_JSON
      end

      use PublicHandler
      use ProtectedHandler
    end
  end
end
