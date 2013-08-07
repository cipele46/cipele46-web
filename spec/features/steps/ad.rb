module AdSteps
  CITIES = ["Zagreb", "Split"]
  CATEGORIES = ["Clothing", "Food"]

  def create_ad(attributes = {})
    create(:ad, attributes)
  end

  def create_categories
    CATEGORIES.each {|name| create(:category, :name => name) }
  end

  def create_cities
    CITIES.each {|name| create(:city, :name => name) }
  end

  def default_ad_attributes
    {:ad_type => :supply, :title => "This is the new ad", :description => "This is the new ad",
      :city => "Zagreb", :category => "Clothing", :phone => "+3859222222", :email => "email@email.com"}
  end

  def fill_in_ad_details(attributes = default_ad_attributes)
    choose "rdb-#{Ad.type[attributes[:ad_type]]}" unless attributes[:ad_type].blank?
    fill_in "ad[title]", with: attributes[:title] if attributes[:title]
    fill_in "ad[description]", with: attributes[:description] if attributes[:description]
    select attributes[:city], from: "ad_city_id" 
    select attributes[:category], from: "ad_category_id" 
    fill_in "ad[phone]", with: attributes[:phone] if attributes[:phone]
    fill_in "ad[email]", with: attributes[:email] if attributes[:email]
  end

  def submit_ad
    find("input.btn").click
  end

  def should_be_required(field)
    fill_in_ad_details(default_ad_attributes.merge({field => ""}))

    submit_ad

    page.should(have_css("span.error", count: 1))
  end

  def should_not_be_required(field)
    fill_in_ad_details(default_ad_attributes.merge({field => ""}))

    submit_ad

    current_path.should eq(ad_path(Ad.last))

    expect_to_see_details_for Ad.last

    visit new_ad_path
  end
end
