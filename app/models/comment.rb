class Comment < ActiveRecord::Base

  include LikesHelper

  default_scope -> { includes(:user, :likers).order('created_at ASC') }

  validates :content, presence: true, length: { maximum: 1000 }
  validates :user_id, presence: true
  validates :post_id, presence: true

  belongs_to :user
  belongs_to :post

  has_many :likes, as: :likeable
  has_many :likers, through: :likes, source: :user
end
