class Category < ActiveRecord::Base
  attr_accessible :name
  has_many :ads

  default_scope order(:name)
end
