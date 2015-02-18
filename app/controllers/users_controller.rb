class UsersController < ApplicationController
  def show
    @user  = User.find(params[:id])
    @posts = @user.posts.includes(:likes)
  end
end
