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

  def expect_to_see_text(text)
    page.should have_content(text)
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

  def expect_not_to_see(ads)
    ads.map do |ad|
      page.should_not have_content(ad.title)
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

  def default_attributes
    {:ad_type => :supply, :title => "This is the new ad", :description => "This is the new ad",
      :city => "Zagreb", :category => "Clothing", :phone => "+3859222222", :email => "email@email.com"}
  end

  def fill_in_ad_details(attributes = default_attributes)
    choose "oglas_ad_type_#{Ad.type[attributes[:ad_type]]}" unless attributes[:ad_type].blank?
    fill_in "Title", with: attributes[:title] if attributes[:title]
    fill_in "Description", with: attributes[:description] if attributes[:description]
    select attributes[:city], from: "oglas_city_id" 
    select attributes[:category], from: "oglas_category_id" 
    fill_in "Phone", with: attributes[:phone] if attributes[:phone]
    fill_in "Email", with: attributes[:email] if attributes[:email]
  end

  def submit_ad
    click_on "submit-ad"
  end

  def should_be_required(field)
    fill_in_ad_details(default_attributes.merge({field => ""}))

    submit_ad

    within(:css, "div.oglas_#{field}") do
      page.should(have_css("label.error"))
    end
  end

  def should_not_be_required(field)
    fill_in_ad_details(default_attributes.merge({field => ""}))

    submit_ad

    current_path.should eq(ad_path(Ad.last))

    expect_to_see_details_for Ad.last
  end
end
