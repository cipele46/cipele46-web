module DashboardSteps

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

  def find_ad(ad)
    page.find("a", :text => ad.title)
  end
end
