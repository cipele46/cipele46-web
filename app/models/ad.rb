class Ad < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  belongs_to :city
  attr_accessible :description, :status, :title, :type, :category_id, :user_id, :city_id, :image
  
  mount_uploader :image, ImageUploader

end
