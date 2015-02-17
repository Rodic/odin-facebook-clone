class Post < ActiveRecord::Base

  include LikesHelper
  
  validates :content, presence: true
  validates :user_id, presence: true

  belongs_to :user
  has_many :comments

  has_many :likes, as: :likeable
end
