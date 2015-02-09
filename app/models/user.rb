class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  # matcher taken from: http://www.regular-expressions.info/email.html
  EMAIL_MATCHER = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i

  validates :password, length: { minimum: 8, maximum: 50 }
  validates :email,    length: { maximum: 50 }, format: { with: EMAIL_MATCHER }
end
