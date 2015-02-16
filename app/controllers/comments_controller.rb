class CommentsController < ApplicationController

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.post_id = params[:post_id]
    if @comment.save
      redirect_to post_path(params[:post_id]), notice: "Comment added successfully!"
    else
      @post = @comment.post
      flash.now[:warning] = "Faild to post comment!"
      render 'posts/show'
    end
  end

  private
  
    def comment_params
      params.require(:comment).permit(:content)
    end

end
