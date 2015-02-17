class LikesController < ApplicationController

  def create
    likeable = find_likeable
    Like.create(likeable: likeable, user: current_user)
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
