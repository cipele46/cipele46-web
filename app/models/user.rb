class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name

  has_many :ads


  def name
    "#{self.first_name} #{self.last_name}"
  end

end
