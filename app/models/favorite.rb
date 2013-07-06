class Favorite < ActiveRecord::Base
  belongs_to :ad
  belongs_to :user
  # attr_accessible :title, :body
end
