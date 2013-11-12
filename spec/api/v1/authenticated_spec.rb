require "spec_helper"
require "pry"

include AuthenticationHelper
include ApiHelpers

describe "API" do
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
            post "#{ads_api_path}", {:ad => valid_ad_params}.to_json,
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

            put "#{ads_api_path}/#{ad.id}", {:ad => ad_params}.to_json,
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

    end # ads

    describe "changing current user data" do
      context "PUT /api/users/current" do
        before do
          @user = create_user
          user_params = {"first_name" => "Pero"}
          put "#{users_api_path}/current", {:user => user_params}.to_json,
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
end # API
