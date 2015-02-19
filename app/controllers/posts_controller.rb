class PostsController < ApplicationController

  def index
    @posts = current_user.timeline.paginate(:page => params[:page], :per_page => 20)
    @post = current_user.posts.build
  end

  def create
    p = post_from_params
    if p.save
      flash[:notice] = "Your post has been successfully created!"
    else
      flash[:warning] = "Post creation failed!"
    end
    redirect_to posts_path
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  private
  
    def post_from_params
      Post.new do |p|
        p.user_id = current_user.id
        p.content = params[:post][:content]
      end
    end
end
