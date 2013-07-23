class Region < ActiveRecord::Base
  attr_accessible :name
  has_many :cities

  default_scope order(:name)
  
  def ads
    Ad.where(city_id: cities.map(&:id))
  end
end
