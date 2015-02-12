class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  # matcher taken from: http://www.regular-expressions.info/email.html
  EMAIL_MATCHER = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i

  validates :password, length: { minimum: 8, maximum: 50 }
  validates :email,    length: { maximum: 50 }, format: { with: EMAIL_MATCHER }

  has_many :initiated_friendships, foreign_key: :user_1_id, class: Friendship
  has_many :accepted_friendships,  foreign_key: :user_2_id, class: Friendship
  
  has_many :initiated_friends, through: :initiated_friendships, source: :user_2, class: User
  has_many :accepted_friends,  through: :accepted_friendships,  source: :user_1, class: User

  def friendships
    Friendship.where('user_1_id=? OR user_2_id=?', id, id)
  end
  
  def friends
    User.joins("JOIN friendships f ON (users.id = f.user_1_id OR users.id = f.user_2_id)")
        .where("users.id <> ? AND (f.user_1_id = ? OR f.user_2_id = ?)", id, id, id)
        .where("f.user_1_status = 'active' AND f.user_2_status = 'active'")
  end
  
  def friend_requests
    accepted_friendships.where("user_2_status='pending'")
  end

  def add_friend(user)
    Friendship.create(user_1: self, user_2: user, user_1_status: 'active', user_2_status: 'pending')
  end
end
