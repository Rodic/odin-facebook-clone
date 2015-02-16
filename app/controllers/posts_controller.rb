class PostsController < ApplicationController

  def index
    @post = current_user.posts.build
  end

  def create
    p = Post.new(post_params)
    if p.save
      flash[:notice] = "Your post has been successfully created!"
    else
      flash[:warning] = "Post creation failed!"
    end
    redirect_to posts_path
  end

  private
  
    def post_params
      params.require(:post).permit(:content, :user_id)
    end
end
