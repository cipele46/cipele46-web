module AdHelper
  def seed_ads
    [[:demand, "I need some nutella here!"],[:supply, "I'm giving away honey"]].each do |type, description|
      create(:ad, ad_type: Ad.type[type], title: "#{description}")
    end
  end

  def giving_ad; @giving_ad ||= Ad.giving.first; end
  def receiving_ad; @receiving_ad ||= Ad.receiving.first; end
  def ad; @ad ||= Ad.all.sample; end

  def filter(opts = {})
    page.find("li.#{opts[:for]} a")
  end

  def enter_search(opts = {})
    ad = opts[:for]

    query = ad.title.split(" ").sample
    page.fill_in("query", :with => query)
    page.click_on("search-button")
  end

  def expect_to_see_ads(opts = {})
    page.should have_selector(".cards-board article.card", opts)
  end

  def expect_to_see_ad(ad)
    expect_to_see_ads(count: 1)
    page.should have_content(ad.title)
  end

  def expect_to_see(what)
    case what
    when :ad
      expect_to_see_ad ad
    when :giving_only
      page.should have_selector(".cards-board article.card", count: Ad.giving.count)
      page.should have_content giving_ad.title
      page.should_not have_content receiving_ad.title
    when :receiving_only
      page.should have_selector(".cards-board article.card", count: Ad.receiving.count)
      page.should have_content receiving_ad.title
      page.should_not have_content giving_ad.title
    when :all
      page.should have_selector(".cards-board article.card", count: Ad.count)
      Ad.all.map do |ad|
        page.should have_content(ad.title)
      end
    end
  end

  def expect_to_see_details_for ad
    [ad.phone, time_ago_in_words(ad.expires_at), ad.description,
      ad.title, ad.category.name, ad.region.name].each do |element|
      page.should have_content(element)
      end
  end

  def find_ad(ad)
    page.find("a", :text => ad.title)
  end
end
