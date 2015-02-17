class LikesController < ApplicationController

  def create
    likeable = find_likeable
    Like.create(likeable: likeable, user: current_user)
    redirect_to(:back)
  end

  def destroy
    like = Like.find(params[:id])
    if like.user = current_user
      like.destroy
    else
      flash[:notice] = "You are not authorized to destroy that 'Like'"
    end
    redirect_to(:back)
  end

  private

    def find_likeable
      params.each do |key, val|
        if key =~ /(.+)_id$/
          return $1.classify.constantize.find(val)
        end
      end
      nil
    end
end
