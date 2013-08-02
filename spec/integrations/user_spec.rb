require "spec_helper"

describe User do
  let(:user) { create(:user) }
  let(:ad) { build(:ad) }

  describe "#toogle_favorite", sunspot_matchers: true do
    context "ad is not already in favorites" do
      it "adds it to favorites" do
        user.toggle_favorite(ad)
        user.reload
        user.favorite_ads.should == [ad]
      end
    end
    context "ad is already in favorites" do
      before { user.favorites.build(ad: ad) }
      it "removes it from favorites" do
        user.toggle_favorite(ad)
      end
    end

  end
end
