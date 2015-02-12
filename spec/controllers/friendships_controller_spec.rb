require 'rails_helper'

RSpec.describe FriendshipsController, type: :controller do

  describe "#create" do

    let(:user)   { FactoryGirl.create(:user) }
    let(:friend) { FactoryGirl.create(:user, email: 'friend@odin-facebook.com') }

    before { sign_in user }

    it 'redirects back to user page' do
      expect(post :create, friend_id: friend.id).to redirect_to(user_path(friend))
    end

    it 'creates new friendship' do
      expect{post :create, friend_id: friend.id}.to change(Friendship, :count).by(1)
    end
  end
end
