class Ad < ActiveRecord::Base

  include Extensions::Ad::Expiration
  include Extensions::Ad::Type
  include Extensions::Ad::Status
  include Extensions::Ad::Delegation
  include Extensions::Ad::Searchable
  include Extensions::Ad::Pagination

  belongs_to :category
  belongs_to :user
  belongs_to :city
  has_many :favorites, :dependent => :destroy
  #has_many :replies, :dependent => :destroy

  attr_accessible :description, :status, :title, :ad_type, :category_id, :user_id, :city_id, :image, :phone,
    :email

  mount_uploader :image, ImageUploader

  scope :active, -> { where("ads.created_at >= :date", :date => VALID_FOR.days.ago).where(status: 2) }
  scope :closed, -> { where(status: 3) }
  scope :by_user_favorites, ->(user_id) { joins(:favorites).where("favorites.user_id = ?", user_id) }
  scope :supply, where(:ad_type => self.type[:supply])
  scope :demand, where(:ad_type => self.type[:demand])

  default_scope includes({ city: :region }, :category)
  
  validates :category_id, :presence => true
  validates :city_id, :presence => true
  validates :description, :presence => true
  validates :title, :presence => true
  validates :ad_type, :presence => true
  validate :phone_or_email_must_be_present

  def phone_or_email_must_be_present
    if !phone.present? && !email.present? then
      errors.add(:phone, "Obavezan je ili telefon ili email")
      errors.add(:email, "Obavezan je ili telefon ili email")
    end
  end
end
