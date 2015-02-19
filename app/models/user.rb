class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
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

  def friendships
    Friendship.where('user_1_id=:id OR user_2_id=:id', id: id)
  end
  
  def friends
    User.joins("JOIN friendships f ON (users.id = f.user_1_id OR users.id = f.user_2_id)")
        .where("users.id <> :id AND (f.user_1_id = :id OR f.user_2_id = :id)", id: id)
        .where("f.user_1_status = 'active' AND f.user_2_status = 'active'")
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

  def liked?(likeable)
    case likeable.class.name 
    when "Post"
      @liked_posts    ||= likeable_array_to_hash(Like.where(user: self, likeable_type: 'Post'))
      @liked_posts[likeable.id]
    when "Comment"
      @liked_comments ||= likeable_array_to_hash(Like.where(user: self, likeable_type: 'Comment'))
      @liked_comments[likeable.id]
    else
    end
  end
  
  private

    def likeable_array_to_hash(likeables)
      likeables.inject(Hash.new) { |acc, likeable| acc[likeable.likeable_id] = likeable.id; acc }
    end

    def build_empty_profile
      Profile.create!(user: self)
    end
end
