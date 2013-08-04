#encoding: utf-8

module DashboardSteps
  private

    def seed_ads
      [[:demand, "I need some nutella here!"],[:supply, "I'm giving away some honey"]].each do |type, description|
        create(:ad, ad_type: Ad.type[type], title: "#{description}", description: "#{description}")
      end
    end

    def giving_ad; @giving_ad ||= Ad.giving.first; end
    def receiving_ad; @receiving_ad ||= Ad.receiving.first; end
    def ad; @ad ||= Ad.all.sample; end

  public

  step "there are ads" do
    setup_solr
    seed_ads
  end

  step "I visit the dashboard" do
    visit root_path
  end

  step 'I click on giving ads filter' do
    page.find("li.giving a").click
  end

  step "I click on all ads" do
    page.find("li.all a").click
  end

  step "I should see all ads" do
    page.should have_selector(".cards-board article.card", count: Ad.count)
    Ad.all.map do |ad|
      page.should have_content(ad.title)
    end
  end

  step 'I should see only the receiving ads' do
    page.should have_selector(".cards-board article.card", count: Ad.receiving.count)
    page.should have_content receiving_ad.title
    page.should_not have_content giving_ad.title
  end

  step 'I click on receiving ads filter' do
    page.find("li.receiving a").click
  end

  step 'I should see only the giving ads' do
    page.should have_selector(".cards-board article.card", count: Ad.giving.count)
    page.should have_content giving_ad.title
    page.should_not have_content receiving_ad.title
  end

  step 'I click to see the ad details' do
    page.find("a", :text => ad.title).click
  end

  step 'I should see the ad details' do
      [ad.phone,
      time_ago_in_words(ad.expires_at),
      ad.description,
      ad.title,
      ad.category.name,
      ad.region.name].each do |element|
        page.should have_content(element)
    end
  end

  step 'I enter the search query' do
    query = ad.description.split(" ").sample
    page.fill_in("query", :with => query)
    page.click_on("search-button")
  end

  step 'I should see only the ads that match the query' do
    page.should have_selector(".cards-board article.card")
    page.should have_content(ad.title)
  end

  step 'I click on the blog' do
    page.find("a", :text => "blog").click
  end

  step 'I should see a blog' do
    page.current_path.should == blog_index_path
  end

  step 'I click on our story' do
    page.find("a", :text => "naša priča").click
  end

  step 'I should see our story' do
    page.current_path.should == page_path("nasa-prica")
  end
end
