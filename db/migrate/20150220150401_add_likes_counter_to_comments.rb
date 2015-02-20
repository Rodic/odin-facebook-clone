class AddLikesCounterToComments < ActiveRecord::Migration
  def change
    add_column :comments, :likes_counter, :integer, default: 0
  end
end
