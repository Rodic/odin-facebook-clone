require 'rails_helper'

RSpec.describe FriendshipsController, type: :controller do

  describe "index" do
    
    let(:user) { FactoryGirl.create(:user) }

    before { sign_in user }

    it "renders correct template" do
      expect(get :index, user_id: user.id).to render_template('index')
    end
  end

  describe "create" do

    let(:user)   { FactoryGirl.create(:user) }
    let(:friend) { FactoryGirl.create(:user, email: 'friend@odin-facebook.com') }

    before { sign_in user }

    it 'redirects back to user page' do
      expect(post :create, user_id: user.id, friend_id: friend.id).to redirect_to(user_path(friend))
    end

    it 'creates new friendship' do
      expect{post :create, user_id: user.id, friend_id: friend.id}.to change(Friendship, :count).by(1)
    end
  end

  describe "update" do

    let(:user)   { FactoryGirl.create(:user) }
    let(:friend) { FactoryGirl.create(:user, email: 'friend@odin-facebook.com') }

    before do
      friend.add_friend(user)
      sign_in user
    end

    it "redirects back to caller" do
      expect(put :update, id: Friendship.last).to redirect_to(user_friendships_path(user))
    end
  end
end
