class Profile < ActiveRecord::Base

  validates :gender,   inclusion: { in: %w{Male Female Other} }
  validates :age,      inclusion: { in: 1..120 }
  validates :about_me, length: { maximum: 1000 }

  belongs_to :user
end
