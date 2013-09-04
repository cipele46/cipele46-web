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
end
