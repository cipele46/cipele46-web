class Ad < ActiveRecord::Base
  VALID_FOR = 30 # in days
  TYPES     = { :supply => 1, :demand => 2 }
  STATUS    = { :pending => 1, :active => 2, :closed => 3 }

  belongs_to :category
  belongs_to :user
  belongs_to :city
  has_many :favorites, :dependent => :destroy

  attr_accessible :description, :status, :title, :ad_type, :category_id, :user_id, :city_id, :image, :phone, :email

  mount_uploader :image, ImageUploader

  scope :active, lambda { where("ads.created_at >= :date", :date => 1.month.ago).where(status: 2) }
  scope :supplies, where(ad_type: 1)
  scope :demands, where(ad_type: 2)

  scope :by_region, lambda { |region_id|
    region = Region.find(region_id)
    Ad.where(city_id: region.cities.map(&:id))
  }
  scope :by_category, lambda {|category_id| where(category_id: category_id)}
  scope :by_type, lambda {|type| where(ad_type: TYPES[type.to_sym])}
  scope :by_query, lambda { |query|
    joins(:city => :region).joins(:category).where("title like :q or description like :q or regions.name like :q or cities.name like :q or categories.name like :q", :q => "%#{query}%")
  }

  validates :category_id, :presence => true
  validates :city_id, :presence => true
  validates :description, :presence => true
  validates :phone, :presence => true
  validates :title, :presence => true
  validates :ad_type, :presence => true

  def expires_at
    created_at + VALID_FOR.days
  end

  def supply?
    ad_type.to_i == TYPES[:supply].to_i
  end

  def demand?
    ad_type.to_i == TYPES[:demand].to_i
  end

  def closed?
    Time.current > (created_at + VALID_FOR.days)
  end

  def region
    city.region
  end

  def set_status
    self.status = if supply?
      STATUS[:pending]
    elsif demand?
      STATUS[:active]
    else
      STATUS[:closed]
    end
  end

end
