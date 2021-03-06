class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable
  
  # matcher taken from: http://www.regular-expressions.info/email.html
  EMAIL_MATCHER = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i
  
  validates :password, length: { minimum: 8, maximum: 50 }
  validates :email,    length: { maximum: 50 }, format: { with: EMAIL_MATCHER }
  
  has_many :initiated_friendships,  foreign_key: :user_1_id, class: Friendship
  has_many :friendships_invited_to, foreign_key: :user_2_id, class: Friendship
  
  has_many :invited_users,    through: :initiated_friendships,  source: :user_2, class: User
  has_many :users_invited_by, through: :friendships_invited_to, source: :user_1, class: User
  
  has_many :posts
  has_many :comments

  has_many :likes

  has_one :profile

  after_create :build_empty_profile

  default_scope -> { order('id ASC') }

  def friendships
    Friendship.where('user_1_id=:id OR user_2_id=:id', id: id)
  end
  
  def friends
    User.joins("JOIN friendships f ON (users.id = f.user_1_id OR users.id = f.user_2_id)")
        .where("users.id <> :id AND (f.user_1_id = :id OR f.user_2_id = :id)", id: id)
        .where("f.user_1_status = 'active' AND f.user_2_status = 'active'")
  end

  def potential_friends
    related = User.joins("JOIN friendships f ON (users.id = f.user_1_id OR users.id = f.user_2_id)")
              .where("(f.user_1_id = :id OR f.user_2_id = :id)", id: id).uniq.ids
    User.where.not(id: related)
  end
  
  def friend_requests
    friendships_invited_to.where("user_2_status='pending'")
  end
  
  def sent_requests
    initiated_friendships.where("user_2_status='pending'")
  end
  
  def add_friend(user)
    Friendship.create(user_1: self, user_2: user, user_1_status: 'active', user_2_status: 'pending')
  end
  
  def friend?(other)
    ids = { id_1: self.id, id_2: other.id }
    Friendship.where('user_1_id=:id_1 AND user_2_id=:id_2 OR user_1_id=:id_2 AND user_2_id=:id_1', ids).first
  end
  
  def addable?(other)
    self != other && !other.friend?(self)
  end
  
  def timeline
    Post.where(user_id: friends.ids << id).includes(:user, :comments, :likes).order('created_at DESC')
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.find_by(provider: access_token.provider, uid: access_token.uid)
    if user
      return user
    else
      registered_user = User.find_by_email(access_token.info.email)
      if registered_user
        return registered_user
      else
        user = User.create!(provider: access_token.provider, email: data["email"], uid: access_token.uid ,
                            password: Devise.friendly_token[0,20])
        UserMailer.welcome_email(user).deliver unless user.invalid?
        user
      end
    end
  end
  
  private

    def build_empty_profile
      Profile.create!(user: self)
    end
end
