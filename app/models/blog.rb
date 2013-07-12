class Blog < ActiveRecord::Base
  attr_accessible :content, :image, :title, :slug
  mount_uploader :image, BlogImageUploader
  validates :title, :presence => true

  extend FriendlyId
  friendly_id :title, use: :slugged

end
