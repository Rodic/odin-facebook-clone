class UsersController < ApplicationController

  def index
    @potential_friends = current_user.potential_friends.paginate(:page => params[:page], :per_page => 20)
  end

  def show
    @user  = User.find(params[:id])
    @posts = @user.posts.includes(:likes)
  end
end
