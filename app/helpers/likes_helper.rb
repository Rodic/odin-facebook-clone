module LikesHelper

  def liked_by?(user)
    likers.include?(user)
  end
end
