module SharedSteps
  module ExpectToSee
    def expect_to_see_ads(opts = {})
      page.should have_selector(".cards-board article.card", opts)
    end

    def expect_to_see_ad(ad)
      expect_to_see_ads(count: 1)
      page.should have_content(ad.title)
    end

    def expect_to_see_text(text)
      page.should have_content(text)
    end

    def expect_not_to_see_text(text)
      expect(page).not_to have_content(text)
    end

    def expect_to_see_details_for ad
      current_path.should == ad_path(ad)

      [ad.phone, time_ago_in_words(ad.expires_at), ad.description,
        ad.title, ad.category.name, ad.region.name].each do |element|
        page.should have_content(element)
        end
    end

    def expect_to_see(what)
      case what
      when String
        expect_to_see_text what
      when Ad
        expect_to_see_ad ad
      when Array
        ads = what
        page.should have_selector(".cards-board article.card", count: ads.count)
        ads.map do |ad|
          page.should have_content(ad.title)
        end
      end
    end

    def expect_not_to_see(what)
      case what
      when String
        expect_not_to_see_text(what)
      when Array
        ads = what
        ads.map do |ad|
          page.should_not have_content(ad.title)
        end
      end
    end
  end

  module HTML
    def link(text)
      page.find("a", :text => text)
    end
  end

  module Debug
    def debug_html
      save_and_open_page
    end
  end
end
