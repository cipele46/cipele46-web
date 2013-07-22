class Ad < ActiveRecord::Base
  PER_PAGE  = 20

  belongs_to :category
  belongs_to :user
  belongs_to :city
  has_many :favorites, :dependent => :destroy

  attr_accessible :description, :status, :title, :ad_type, :category_id, :user_id, :city_id, :image, :phone,
    :email

  mount_uploader :image, ImageUploader

  scope :active, -> { where("ads.created_at >= :date", :date => VALID_FOR.days.ago).where(status: 2) }
  scope :by_user_favorites, ->(user_id) { joins(:favorites).where("favorites.user_id = ?", user_id) }

  default_scope includes({ city: :region }, :category)
  
  validates :category_id, :presence => true
  validates :city_id, :presence => true
  validates :description, :presence => true
  validates :phone, :presence => true
  validates :title, :presence => true
  validates :ad_type, :presence => true

  searchable do
    text :title, boost: 4.0
    text :description, boost: 2.0
    text :phone
    text :category do
      category.name
    end
    text :city do
      city.name
    end
    text :region do 
      city.region.name 
    end

    integer :region_id do
      city.region_id
    end
    integer :category_id
    integer :ad_type
    integer :status
    time :created_at
  end

  include Extensions::Ad::Expiration
  include Extensions::Ad::Type
  include Extensions::Ad::Status
  include Extensions::Ad::Delegation

  def self.search(ad_filter, page = nil, per_page = nil)
    print ad_filter.to_yaml
    Sunspot.search(Ad) do
      fulltext(ad_filter.query) if ad_filter.query
      with(:category_id, ad_filter.category_id) if ad_filter.category_id
      with(:region_id, ad_filter.region_id) if ad_filter.region_id
      with(:ad_type, ad_filter.ad_type) if ad_filter.ad_type
      with(:status, 2)
      facet(:category_id)
      facet(:region_id)
      facet(:ad_type)
      paginate(page: page || 1, per_page: per_page)
      order_by(:created_at, :desc) if ad_filter.query.blank?
    end
  end
end
