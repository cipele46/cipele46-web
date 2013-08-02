class Favorite < ActiveRecord::Base
  attr_accessible :ad

  belongs_to :ad
  belongs_to :user
  # attr_accessible :title, :body
end
