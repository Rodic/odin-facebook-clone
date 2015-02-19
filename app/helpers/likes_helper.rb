module LikesHelper

  def liked_by?(user)
    # depends on User default_scope, i.e. ordering
    likers.bsearch { |l| user.id - l.id }
    #likers.include?(user)
  end
end
