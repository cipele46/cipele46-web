class Ad < ActiveRecord::Base
  TYPES = { :supply => 1, :demand => 2 }
  STATUS = { :pending => 1, :active => 2, :closed => 3 }

  belongs_to :category
  belongs_to :user
  belongs_to :city
  attr_accessible :description, :status, :title, :type, :category_id, :user_id, :city_id, :image
  
  mount_uploader :image, ImageUploader

  scope :active, lambda { where("created_at >= :date", :date => 1.month.ago) } 
  scope :offers, where(type: 1)
  scope :demands, where(type: 2)

end
