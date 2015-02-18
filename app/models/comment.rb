class Comment < ActiveRecord::Base

  include LikesHelper

  default_scope -> { includes(:user, :likes).order('created_at DESC') }

  validates :content, presence: true, length: { maximum: 1000 }
  validates :user_id, presence: true
  validates :post_id, presence: true

  belongs_to :user
  belongs_to :post

  has_many :likes, as: :likeable
end
