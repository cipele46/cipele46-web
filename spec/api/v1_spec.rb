# encoding: utf-8
require "spec_helper"
require "pry"

include AuthenticationHelper
include ApiHelpers

describe "API" do
  context "for unauthenticated users" do
    describe "categories API" do
      before do
        @categories = []
        @categories << create(:category, :name => "Clothing")
        @categories << create(:category, :name => "Food")
      end

      context "fetching the list of categories" do
        before do
          get categories_api_path
        end

        it "returns JSON data for all categories" do
          @categories.each.zip(json_response) do |category,json|
            expect(json["id"]).to eq(category.id)
            expect(json["name"]).to eq(category.name)
          end
        end
      end
    end

    describe "regions and cities" do
      before do
        @bjelovarska = create(:region, :name => "Bjelovarsko-Bilogorska")
        @krapinska = create(:region, :name => "Krapinsko-Zagorska")
        @krapina = create(:city, :name => "Krapina", :region => @krapinska)
        @bjelovar = create(:city, :name => "Bjelovar", :region => @bjelovarska)
      end

      context "fetching the list of regions" do
        subject do
          get regions_api_path
          JSON.parse response.body
        end

        it "returns JSON data for all regions" do
          should == [
            {"id" => @bjelovarska.id, "name" => @bjelovarska.name,
            "cities" => [{"id" => @bjelovar.id, "name" => @bjelovar.name}] },

            {"id" => @krapinska.id, "name" => @krapinska.name,
            "cities" => [{"id" => @krapina.id, "name" => @krapina.name}] },
          ]
        end
      end
    end

    describe "registration" do
      context "POST /api/users" do
        context "when email has not been taken" do
          before do
            @params = {"user"=> { "first_name"=> "Pero", "last_name"=> "Peric", "email"=> "pero@cipele46.org",
              "phone"=> "123455", "password"=> "pwd1234", "password_confirmation"=> "pwd1234" }}

            post users_api_path, @params
            @it = json_response
          end

          it "returns JSON success" do
            @it.should == @params["user"].select {|k,v| k !~ /password/}.merge("id" => User.last.id)
          end
        end
        context "when email has been taken" do
          before do
            create(:user, :email => "pero@cipele46.org")
            @params = {"user"=> { "first_name"=> "Pero", "last_name"=> "Peric", "email"=> "pero@cipele46.org",
              "phone"=> "123455", "password"=> "pwd1234", "password_confirmation"=> "pwd1234" }}

            post users_api_path, @params
          end

          it "returns JSON error" do
            expect(response.status).to eq(500)
          end

          it "returns nice JSON error message" do
            expect(json_response["error"]["message"]).to be_present
          end
        end
      end
    end

    describe "ads" do
      describe "listing" do
        context "GET /api/v1/ads", :search => true do
          before do
            create_user_with_ads
            sleep(4)
            get ads_api_path
          end
          it "returns JSON success" do
            response.status.should eq(200)
          end
          it "returns all active ads" do
            expect(json_response.count).to eq(Ad.active.count)
          end
        end
      end

      describe "fetching" do 
        context "GET /api/ads?page=2&per_page=1&ad_type=1&status=2&category_id=1&region_id=1&query=query" do
          it "returns JSON success" do
            params = {"page" => "2", "per_page" => "1", "ad_type" => "1",
              "status" => "2", "category_id" => "1","region_id" => "1",
              "query" => "query"}
            pending "needs new integration tests"
          end
        end
      end
    end # ads

    context "unauthorized requests" do
      describe "changing current user data" do
        context "PUT /api/users/current" do
          before do
            user_params = {"first_name" => "Pero"}

            put "#{users_api_path}/current", {:user => user_params}
          end
          it "returns JSON unauthorized" do
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

        describe "adding/removing it from/to favorites" do
          context "PUT /api/ads/1/toggle_favorite" do
            it "returns JSON unauthorized" do
              ad_id = 1

              put "#{api_path}/ads/#{ad_id}/toggle_favorite", {}

              response.should be_unauthorized
            end
          end
        end

      end # ads
    end # unauthorized requests
  end # for unauthenticated users

  context "for authenticated users" do

    context "ads" do
        describe "fetching", :search => true do 
          context "GET /api/ads?user=1" do
            before do
              create(:ad)
              @user = create_user_with_ads
              sleep(4)
              params = {"user" => @user.id}
              get ads_api_path, params, 
                {"HTTP_AUTHORIZATION" => valid_credentials }
            end
            it "returns JSON success" do
              expect(response.status).to eq(200)
            end
            it "returns JSON of user's ads" do
              expect(json_response.count).to eq(@user.ads.active.count)
            end
          end

          context "GET /api/ads?favorites=1&query=query" do
            before do
              @user = create_user
              @ad1 = create(:ad, :user => @user, :title => "bart simpson")
              @ad2 = create(:ad, :user => @user, :title => "lisa simpson")
              @ad3 = create(:ad, :user => @user, :title => "homer simpson")
              sleep(4)
              
              @user.favorite_ads << [@ad1, @ad2]

            end

            context "filtering favorites" do
              before do
                params = {"favorites" => "1", "query" => "lisa"}
                get "#{api_url}/ads", params,
                  {"HTTP_AUTHORIZATION" => valid_credentials }
              end

              it "returns JSON success" do
                expect(response.status).to eq(200)
              end

              it "returns the targeted ad" do
                expect(json_response.count).to eq(1)
                expect(json_response.first["title"]).to eq("lisa simpson")
              end
            end

            context "don't return ads that are not favorites" do
              before do
                params = {"favorites" => "1", "query" => "homer"}
                get "#{api_url}/ads", params,
                  {"HTTP_AUTHORIZATION" => valid_credentials }
              end

              it "returns JSON success" do
                expect(response.status).to eq(200)
              end

              it "response is empty" do
                expect(json_response).to be_blank
              end
            end
          end
        end
      describe "creating with POST /api/ads" do
        context "with valid params" do
          before do
            create_user
            post "#{ads_api_path}", {:ad => valid_ad_params},
              {"HTTP_AUTHORIZATION" => valid_credentials}
          end
          it "returns JSON success" do
            response.status.should eq(200)
          end

          it "return JSON presentation of ad" do
            expect(json_response["title"]).to eq(valid_ad_params["title"])
          end
        end

        context "with invalid params" do
          before do
            create_user
            post "#{ads_api_path}", {:ad => valid_ad_params.merge("title" => "")},
              {"HTTP_AUTHORIZATION" => valid_credentials}
          end
          it "returns JSON error" do
            response.status.should eq(500)
          end

          it "returns nice JSON error message" do
            expect(json_response["error"]["message"]).to be_present
          end
        end
      end

      describe "editing" do
        context "PUT /api/ads/1" do
          before do
            create_user_with_ads
            ad = Ad.first
            ad_params = {"title" => "new title"}

            put "#{ads_api_path}/#{ad.id}", {:ad => ad_params},
            {"HTTP_AUTHORIZATION" => valid_credentials }
          end

          it "returns JSON success" do
            response.status.should eq(200)
          end

          it "returns JSON with updated title" do
            expect(json_response["title"]).to eq("new title")
          end
        end
      end

      describe "removing" do
        context "DELETE /api/ads/1" do
          before do
            create_user_with_ads
            @ad = Ad.first

            delete "#{ads_api_path}/#{@ad.id}", {},
            {"HTTP_AUTHORIZATION" => valid_credentials }
          end

          it "returns JSON success" do
            response.status.should eq(200)
          end

          it "returns JSON for the ad" do
            expect(json_response["title"]).to eq(@ad.title)
          end
        end
      end

      describe "adding/removing it from/to favorites" do
        context "PUT /api/ads/1/toggle_favorite" do
          before do
            @user = create_user
            @ad = create(:ad)
            put "#{api_path}/ads/#{@ad.id}/toggle_favorite", {}, 
            {"HTTP_AUTHORIZATION" => valid_credentials}
          end
          it "returns JSON success" do
            response.status.should eq(200)
          end

          it "returns the ad" do
            expect(json_response["title"]).to eq(@ad["title"])
          end

          it "updates user's favorites" do
            expect(@user.favorite_ads.first).to eq(@ad)
          end
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
        before do
          @user = create_user
          user_params = {"first_name" => "Pero"}
          put "#{users_api_path}/current", {:user => user_params},
            {"HTTP_AUTHORIZATION" => valid_credentials }
        end
        it "returns JSON success" do
          response.status.should eq(200)
        end

        it "returns updated user" do
          expect(json_response["first_name"]).to eq("Pero")
        end
      end
    end

    describe "login" do
      context "GET /api/users/current" do
        before do
          @user = create_user_with_ads
          get "#{users_api_path}/current", {}, {"HTTP_AUTHORIZATION" => valid_credentials}
        end
        it "returns JSON success" do
          response.status.should eq(200)
        end

        it "returns logged in user" do
          expect(json_response["id"]).to eq(@user.id)
        end
      end
    end
  end # for authenticated users

  describe "login via FB"
end

def valid_ad_params
  city = create(:city)
  category = create(:category)

  {"title" => "new title",
    "description" => "new description",
    "category_id" => category.id, "city_id" => city.id,
    "phone" => "123456", "ad_type" => Ad.type[:supply] }
end

def create_user_with_ads
  user = create_user
  3.times { create(:ad, :user => user) }
  user
end

def create_user
  create(:user, :email => USERNAME, :password => PASSWORD, :password_confirmation => PASSWORD)
end

