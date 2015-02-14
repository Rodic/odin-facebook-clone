class FriendshipsController < ApplicationController

  def index
    @user = User.find(params[:user_id])
  end

  def requests
  end

  def create
    friend = User.find(params[:friend_id])
    current_user.add_friend(friend)
    redirect_to user_path(friend), notice: "You asked #{friend.email} to be your friend"
  end

  def update
    friendship = Friendship.find(params[:id])
    friendship.activate if friendship.user_2 == current_user
    redirect_to user_friendships_path(friendship.user_2), notice: "You are now firend with #{friendship.user_1.email}"
  end

  def destroy
    friendship = Friendship.find(params[:id])
    friendship.destroy
    redirect_to friendship_requests_path, notice: "You declined #{friendship.user_1.email} friend request"
  end
end
