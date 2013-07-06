class Ad < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  belongs_to :city
  attr_accessible :description, :status, :title, :ad_type, :category_id, :user_id, :city_id, :image
  
  mount_uploader :image, ImageUploader

  scope :active, lambda { where("created_at >= :date", :date => 1.month.ago) } 
  scope :offers, where(ad_type: 1)
  scope :demands, where(ad_type: 2)

  
end
