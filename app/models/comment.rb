class Comment < ActiveRecord::Base

  default_scope -> { includes(:user).order('created_at DESC') }

  validates :content, presence: true, length: { maximum: 1000 }
  validates :user_id, presence: true
  validates :post_id, presence: true

  belongs_to :user
  belongs_to :post

end
