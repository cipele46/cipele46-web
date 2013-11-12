require_relative "./v1/handler"
require_relative "./v1/public_handler"
require_relative "./v1/protected_handler"

require "rabl"
require 'active_support/core_ext'
require 'active_support/inflector'
require 'builder'

module Api 
  module V1
    module Response
     UNAUTHORIZED = {"error" => "Unauthorized"}.to_json
    end

    class Base < APIHandler
      get "/" do
        WELCOME_JSON
      end

      use PublicHandler
      use ProtectedHandler
    end
  end
end
