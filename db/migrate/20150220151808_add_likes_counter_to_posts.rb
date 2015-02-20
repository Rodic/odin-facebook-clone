class AddLikesCounterToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :likes_counter, :integer, default: 0
  end
end
