module ApiHelpers
  def json_response
    JSON.parse(response.body)
  end

  def api_path
    "#{super}/v1"
  end

  def ads_api_path
    "#{api_path}/ads"
  end

  def regions_api_path
    "#{api_path}/regions"
  end

  def categories_api_path
    "#{api_path}/categories"
  end

  def users_api_path
    "#{api_path}/users"
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
end
