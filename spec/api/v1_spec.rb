# encoding: utf-8
require "spec_helper"

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

class MockUser
  def valid_password?(pass)
    pass == PASSWORD
  end
end

def authenticated_user
  user = MockUser.new
  ads  = double("ads")
  User.should_receive(:find_by_email).with(USERNAME) { user }
  user.stub(:ads) { ads }
  user
end

describe "API" do
  context "for unauthenticated users" do
    describe "categories" do
      context "GET /api/v1/categories" do
        it "renders JSON" do
          Category.should_receive(:all)

          get categories_api_path
        end
      end
    end

    describe "regions and cities" do
      context "GET /api/v1/regions" do
        it "renders JSON" do
          Region.should_receive(:all)

          get regions_api_path
        end
      end
    end

    describe "ads" do
      describe "listing" do
        context "GET /api/v1/ads" do
          it "renders JSON" do
            Ad.should_receive(:search).with(instance_of(AdFilter), nil, anything)

            get ads_api_path
          end
        end
      end

      describe "fetching" do 
        context "GET /api/ads?page=2&per_page=1&foo=bar&baz=biz" do
          it "renders JSON" do
            params = {"page" => "2", "per_page" => "1", "foo" => "bar", "baz" => "biz"}

            AdFilter.should_receive(:new).with(params.with_indifferent_access).and_call_original
            Ad.should_receive(:search).with(instance_of(AdFilter), "2", "1")

            get ads_api_path, params
          end
        end
      end
    end

    describe "registration" do
      context "POST /api/users" do
        it "renders JSON" do
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

  end
  context "for authenticated users" do
    describe "creating" do
      context "POST /api/ads" do
        it "renders JSON" do

          ad = double("ad")

          ad_params = {"title" => "new title", "description" => "new description", "category_id" =>"1", "city_id" =>"1"}

          authenticated_user.ads.should_receive(:create).with(ad_params) { ad }
          ad.should_receive(:to_json)

          post "#{ads_api_path}", {:ad => ad_params},
            {"HTTP_AUTHORIZATION" => valid_credentials}

          response.status.should eq(200)
        end
      end
    end
    describe "editing" do
      context "PUT /api/ads/1" do
        it "renders JSON" do
          id = "1"
          ad = double("ad")
          ad_params = {"title" => "new title"}

          authenticated_user.ads.should_receive(:find).with(id) { ad }
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
        it "renders JSON" do
          id = "1"
          ad = double("ad")

          authenticated_user.ads.should_receive(:find).with(id) { ad }
          ad.should_receive(:destroy) { {} }


          delete "#{ads_api_path}/#{id}", {},
          {"HTTP_AUTHORIZATION" => valid_credentials }

          response.status.should eq(200)
        end
      end
    end
    describe "changing current user data" do
      context "PUT /api/users/current" do
        it "renders JSON" do

          updated_user = double("user")

          user_params = {"first_name" => "Pero"}

          authenticated_user.should_receive(:update_attributes).with(user_params) { updated_user }
          updated_user.should_receive(:to_json)

          put "#{users_api_path}/current", {:user => user_params},
            {"HTTP_AUTHORIZATION" => valid_credentials }

          response.status.should eq(200)
        end
      end
    end

    describe "adding/removing it from/to favorites" do
      context "PUT /api/favorites/toogle/1" do
        it "renders JSON"
      end
    end
    describe "replying" do
      context "POST /api/ads/1/reply" do
        it "renders JSON"
      end
    end
  end

  describe "login"
  describe "login via FB"
end
