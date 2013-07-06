class Blog < ActiveRecord::Base
  attr_accessible :content, :image, :title
  mount_uploader :image, BlogImageUploader
  validates :title, :presence => true
end
