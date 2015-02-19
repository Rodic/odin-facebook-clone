class Post < ActiveRecord::Base

  include LikesHelper
  
  default_scope { includes(:likers) }

  validates :content, presence: true
  validates :user_id, presence: true

  belongs_to :user
  has_many :comments

  has_many :likes, as: :likeable
  has_many :likers, through: :likes, source: :user
end
