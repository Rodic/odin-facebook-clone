class Post < ActiveRecord::Base

  validates :content, presence: true
  validates :user_id, presence: true

  belongs_to :user
  has_many :comments

  has_many :likes, as: :likeable

  def liked_by?(user)
    Like.find_by(likeable: self, user: user)
  end
end
