class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :phone

  has_many :ads
  has_many :favorites
  has_many :favorite_ads, :through => :favorites, :source => :ad

  validates :phone, :presence => true

  include Extensions::User::Naming

  def toggle_favorite(ad)
    case
    when favorite_ads.map(&:id).include?(ad.id) then favorite_ads.destroy(ad.id)
    else favorites.create(ad: ad).ad
    end
  end
end
