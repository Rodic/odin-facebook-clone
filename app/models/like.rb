class Like < ActiveRecord::Base
  
  validates :user_id,     presence: true
  validates :likeable_id, presence: true

  belongs_to :user
  belongs_to :likeable, polymorphic: true

  after_create  :increase_likes_counter, if: -> { likeable }
  after_destroy :decrease_likes_counter, if: -> { likeable }

  def increase_likes_counter
    likeable.increment!(:likes_counter, 1)
  end

  def decrease_likes_counter
    likeable.increment!(:likes_counter, -1)
  end
end
