class CommentsController < ApplicationController

  def create
    @comment = comment_from_params
    if @comment.save
      redirect_to post_path(params[:post_id]), notice: "Comment added successfully!"
    else
      flash[:warning] = "Faild to post comment!"
      redirect_to(@comment.post)
    end
  end

  private
  
    def comment_from_params
      Comment.new do |c|
        c.content = params[:comment][:content]
        c.user_id = current_user.id
        c.post_id = params[:post_id]
      end
    end

end
