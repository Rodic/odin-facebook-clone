class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  # matcher taken from: http://www.regular-expressions.info/email.html
  EMAIL_MATCHER = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i

  validates :password, length: { minimum: 8, maximum: 50 }
  validates :email,    length: { maximum: 50 }, format: { with: EMAIL_MATCHER }

  has_many :initiated_relationships,      foreign_key: :user_1_id, class: Friendship
  has_many :asked_to_be_in_relationships, foreign_key: :user_2_id, class: Friendship
  
  has_many :invited_users,    through: :initiated_relationships,      source: :user_2, class: User
  has_many :invited_by_users, through: :asked_to_be_in_relationships, source: :user_1, class: User

  def relationships
    Friendship.where('user_1_id=? OR user_2_id=?', id, id)
  end
  
  def friends
    User.joins("JOIN friendships f ON (users.id = f.user_1_id OR users.id = f.user_2_id)")
        .where("users.id <> ? AND (f.user_1_id = ? OR f.user_2_id = ?)", id, id, id)
        .where("f.user_1_status = 'active' AND f.user_2_status = 'active'")
  end
  
  def friend_requests
    asked_to_be_in_relationships.where("user_2_status='pending'")
  end

  def sent_requests
    initiated_relationships.where("user_2_status='pending'")
  end

  def add_friend(user)
    Friendship.create(user_1: self, user_2: user, user_1_status: 'active', user_2_status: 'pending')
  end
end
