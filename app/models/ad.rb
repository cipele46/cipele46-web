# encoding: UTF-8

class Ad < ActiveRecord::Base
  TYPES = { "Poklanjam" => 1, "Tražim" => 2 }

  belongs_to :category
  belongs_to :user
  belongs_to :city
  attr_accessible :description, :image_url, :status, :title, :type
end
