class Profile < ActiveRecord::Base

  validates :gender,   inclusion: { in: %w{ Male Female Other } }, allow_nil: true
  validates :age,      inclusion: { in: 1..120 }, allow_nil: true
  validates :about_me, length: { maximum: 1000 }

  belongs_to :user
end
