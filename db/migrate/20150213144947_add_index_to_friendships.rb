class AddIndexToFriendships < ActiveRecord::Migration
  def change
    add_index :friendships, [:user_1_id, :user_2_id], unique: true
  end
end
