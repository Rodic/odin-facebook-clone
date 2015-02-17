module LikesHelper

  def liked_by?(user)
    Like.find_by(likeable: self, user: user)
  end

end
