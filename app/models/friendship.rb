class Friendship < ActiveRecord::Base

  validates :user_1_id,     presence: true
  validates :user_2_id,     presence: true
  validates :user_1_status, inclusion: { in: %w{ active pending blocking } }
  validates :user_2_status, inclusion: { in: %w{ active pending blocking } }
  
  belongs_to :user_1, class: User
  belongs_to :user_2, class: User

  # Raise the same error as Postgres do when unique constraint is violated
  before_save :users_permutations_not_allowed

  def activate
    update_attribute(:user_2_status, 'active')
  end

  private
  
    def users_permutations_not_allowed
      unless Friendship.find_by(user_1: self.user_2, user_2: self.user_1).nil?
        raise ActiveRecord::RecordNotUnique, "Friendship #{user_2.email} - #{user_1.email} is already in DB"
      end
    end
end
