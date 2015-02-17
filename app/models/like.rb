class Like < ActiveRecord::Base
  
  validates :user_id,     presence: true
  validates :likeable_id, presence: true

  belongs_to :user
  belongs_to :likeable, polymorphic: true
end
