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

    describe "regions and cities API" do
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

    describe "registration API" do
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
  describe "login via FB"
end # API
