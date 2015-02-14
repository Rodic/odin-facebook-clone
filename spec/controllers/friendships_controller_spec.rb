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
      expect(post :create, friend_id: friend.id).to redirect_to(user_path(friend))
    end

    it 'creates new friendship' do
      expect{post :create, friend_id: friend.id}.to change(Friendship, :count).by(1)
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

  describe "destroy" do

    let(:user_1) { FactoryGirl.create(:user) }
    let(:user_2) { FactoryGirl.create(:user, email: "friend@odin-facebook.com") }
    let!(:friendship) { FactoryGirl.create(:friendship, user_1: user_1, user_2: user_2, user_2_status: 'pending') }

    before { sign_in user_2 }

    it "redirects back to user requests page" do
      expect(delete :destroy, id: friendship.id).to redirect_to(friendship_requests_path)
    end

    it "deletes friendship record from database" do
      expect{ delete :destroy, id: friendship.id }.to change(Friendship, :count).by(-1)
    end
  end
end
