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

      before do
        content_type :json
      end

      error do
        {"error" => request.env["sinatra.error"]}.to_json
      end

      use PublicHandler
      use ProtectedHandler
    end
  end
end
