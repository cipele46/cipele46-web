class Ad < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  belongs_to :city
  attr_accessible :description, :image_url, :status, :title, :type
end
