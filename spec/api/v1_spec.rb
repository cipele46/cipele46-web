# encoding: utf-8
require "spec_helper"
require "pry"

class ActionDispatch::TestResponse
  def unauthorized?
    body.eql?(Api::V1::Response::UNAUTHORIZED) &&
      status.eql?(401)
  end
end

class String
  def without_version
    gsub("/v1","")
  end
end

def api_path
  "#{super}/v1"
end

def ads_api_path
  "#{api_path}/ads"
end

def regions_api_path
  "#{api_path}/regions"
end

def categories_api_path
  "#{api_path}/categories"
end

def users_api_path
  "#{api_path}/users"
end

USERNAME = "foo"
PASSWORD = "bar"

def encode_credentials(opts = {})
  "Basic #{Base64.encode64("#{opts[:username]}:#{opts[:password]}")}" 
end

def valid_credentials
  encode_credentials(:username => USERNAME, :password => PASSWORD) 
end

class CurrentUser
  # a mock class representing a succesfully authenticated user
  def valid_password?(pass)
    pass == PASSWORD
  end
end

def current_user
  user = CurrentUser.new
  ads  = double("ads")
  User.should_receive(:find_by_email).with(USERNAME) { user }
  user.stub(:ads) { ads }
  user
end

describe "API" do
  context "for unauthenticated users" do
    describe "categories" do
      context "GET /api/v1/categories" do
        it "returns JSON success" do
          Category.should_receive(:all)

          get categories_api_path
        end
      end
    end

    describe "regions and cities" do
      context "GET /api/v1/regions" do
        it "returns JSON success" do
          Region.should_receive(:all)

          get regions_api_path
        end
      end
    end

    describe "registration" do
      context "POST /api/users" do
        it "returns JSON success" do
          user = double("user")

          params = {"user"=> { "first_name"=> "Pero", "last_name"=> "Peric", "email"=> "pero@cipele46.org",
            "phone"=> "123455", "password"=> "pwd1234", "password_confirmation"=> "pwd1234" }}

          User.should_receive(:create).with(params["user"]) { user }
          user.should_receive(:to_json)

          post users_api_path, params

          response.status.should eq(200)
        end
      end
    end

    describe "ads" do
      describe "listing" do
        context "GET /api/v1/ads" do
          it "returns JSON success" do
            results = {}
            search = double(:results => results)

            AdFilter.any_instance.should_receive(:search) { search }
            results.should_receive(:to_json)

            get ads_api_path
            response.status.should eq(200)
          end
        end
      end

      describe "fetching" do 
        context "GET /api/ads?page=2&per_page=1&ad_type=1&status=2&category_id=1&region_id=1&query=query" do
          it "returns JSON success" do
            params = {"page" => "2", "per_page" => "1", "ad_type" => "1",
              "status" => "2", "category_id" => "1","region_id" => "1",
              "query" => "query"}

            results = {}
            search = double(:results => results)

            AdFilter.should_receive(:new).with(params) { Ad }
            Ad.should_receive(:search) { search }
            results.should_receive(:to_json)

            get ads_api_path, params

            response.status.should eq(200)
          end
        end
      end
    end # ads

    context "unauthorized requests" do
      describe "changing current user data" do
        context "PUT /api/users/current" do
          it "returns JSON unauthorized" do
            user_params = {"first_name" => "Pero"}

            put "#{users_api_path}/current", {:user => user_params}

            response.should be_unauthorized
          end
        end
      end

      describe "login" do
        context "GET /api/users/current" do
          it "returns JSON unauthorized" do
            get "#{users_api_path}/current"

            response.should be_unauthorized
          end
        end
      end

      context "ads" do
        describe "creating" do
          context "POST /api/ads" do
            it "returns JSON unauthorized" do
              ad_params = {"title" => "new title", "description" => "new description", "category_id" =>"1", "city_id" =>"1"}

              post "#{ads_api_path}", {:ad => ad_params}

              response.should be_unauthorized
            end
          end
        end

        describe "fetching" do 
          context "GET /api/ads?user=1" do
            it "returns JSON unauthorized" do
              params = {"user" => "1"}

              get ads_api_path, params

              response.should be_unauthorized
            end
          end

          context "GET /api/ads?favorites=1" do
            it "returns JSON unauthorized" do
              params = {"user" => "1"}

              get ads_api_path, params

              response.should be_unauthorized
            end
          end
        end

        describe "editing" do
          context "PUT /api/ads/1" do
            it "returns JSON unauthorized" do
              id = "1"
              ad_params = {"title" => "new title"}

              put "#{ads_api_path}/#{id}", {:ad => ad_params}

              response.should be_unauthorized
            end
          end
        end

        describe "removing" do
          context "DELETE /api/ads/1" do
            it "returns JSON unauthorized" do
              id = "1"

              delete "#{ads_api_path}/#{id}", {}

              response.should be_unauthorized
            end
          end
        end

      end # ads
    end # unauthorized requests
  end # for unauthenticated users

  context "for authenticated users" do

    context "ads" do
        describe "fetching" do 
          context "GET /api/ads?user=1" do
            it "returns JSON success"
          end

          context "GET /api/ads?favorites=1" do
            it "returns JSON success"
          end
        end
      describe "creating" do
        context "POST /api/ads" do
          it "returns JSON success" do

            ad = double("ad")

            ad_params = {"title" => "new title", "description" => "new description", "category_id" =>"1", "city_id" =>"1"}

            current_user.ads.should_receive(:create).with(ad_params) { ad }
            ad.should_receive(:to_json)

            post "#{ads_api_path}", {:ad => ad_params},
              {"HTTP_AUTHORIZATION" => valid_credentials}

            response.status.should eq(200)
          end
        end
      end

      describe "editing" do
        context "PUT /api/ads/1" do
          it "returns JSON success" do
            id = "1"
            ad = double("ad")
            ad_params = {"title" => "new title"}

            current_user.ads.should_receive(:find).with(id) { ad }
            ad.should_receive(:update_attributes).with(ad_params) { ad_params }
            ad_params.should_receive(:to_json)


            put "#{ads_api_path}/#{id}", {:ad => ad_params},
            {"HTTP_AUTHORIZATION" => valid_credentials }

            response.status.should eq(200)
          end
        end
      end

      describe "removing" do
        context "DELETE /api/ads/1" do
          it "returns JSON success" do
            id = "1"
            ad = double("ad")

            current_user.ads.should_receive(:find).with(id) { ad }
            ad.should_receive(:destroy) { {} }


            delete "#{ads_api_path}/#{id}", {},
            {"HTTP_AUTHORIZATION" => valid_credentials }

            response.status.should eq(200)
          end
        end
      end

      describe "adding/removing it from/to favorites" do
        context "PUT /api/favorites/toogle/1" do
          it "returns JSON success"
        end
      end

      describe "replying" do
        context "POST /api/ads/1/reply" do
          it "returns JSON success"
        end
      end
    end # ads

    describe "changing current user data" do
      context "PUT /api/users/current" do
        it "returns JSON success" do

          updated_user = double("user")

          user_params = {"first_name" => "Pero"}

          current_user.should_receive(:update_attributes).with(user_params) { updated_user }
          updated_user.should_receive(:to_json)

          put "#{users_api_path}/current", {:user => user_params},
            {"HTTP_AUTHORIZATION" => valid_credentials }

          response.status.should eq(200)
        end
      end
    end

    describe "login" do
      context "GET /api/users/current" do
        it "returns JSON success" do
          current_user.should_receive(:to_json)

          get "#{users_api_path}/current", {}, {"HTTP_AUTHORIZATION" => valid_credentials}

          response.status.should eq(200)
        end
      end
    end
  end # for authenticated users

  describe "login via FB"
end
