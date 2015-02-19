class UserMailer < ActionMailer::Base
  
  default from: "noreply@odin-facebook.com"

  def welcome_email(user)
    @user    = user
    @profile = edit_profile_url
    mail(to: @user.email, subject: "Welcome to The Odin-Facebook")
  end
end
