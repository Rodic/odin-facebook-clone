class ProfilesController < ApplicationController

  def edit
    @profile = current_user.profile
  end

  def update
    @profile = current_user.profile
    if @profile.update_attributes!(profile_params)
      redirect_to current_user, notice: "Your profile has been updated successfully"
    else
      flash.now[:warning] = "Failed to update profile"
      render 'edit'
    end
  end

  private

    def profile_params
      params.require(:profile).permit(:user_id, :about_me, :gender, :age, 
                                      :city, :country, :work, :website)
    end
end
