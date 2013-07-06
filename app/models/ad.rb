class Ad < ActiveRecord::Base
  VALID_FOR = 30 # in days
  TYPES = { :supply => 1, :demand => 2 }
  STATUS = { :pending => 1, :active => 2, :closed => 3 }

  belongs_to :category
  belongs_to :user
  belongs_to :city

  attr_accessible :description, :status, :title, :ad_type, :category_id, :user_id, :city_id, :image, :phone, :email

  mount_uploader :image, ImageUploader

  scope :active, lambda { where("created_at >= :date", :date => 1.month.ago) }
  scope :supplies, where(ad_type: 1)
  scope :demands, where(ad_type: 2)


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
