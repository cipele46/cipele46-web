require "sinatra"
require "json"

require_relative('../../config/application') 
require_relative("./v1.rb")

module Api
  Base = Rack::Builder.new do
    map "/" do
      # we should support api calls without version
      # like so: GET /api/ads
     
      run Api::V1::Base 
    end

    map "/v1" do
      run Api::V1::Base 
    end
  end
end
