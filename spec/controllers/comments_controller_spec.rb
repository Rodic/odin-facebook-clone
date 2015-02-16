require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe "create" do

    let(:p) { FactoryGirl.create(:post) }
    let(:user) { FactoryGirl.create(:user, email: "commentator@odin-facebook.com") }

    before { sign_in user }

    it "redirects to post page" do
      expect(post :create, post_id: p.id, comment: {content: "test"}).to redirect_to(post_path(p.id))
    end

    it "creates new comment" do
      expect{post :create, post_id: p.id, comment: {content: "test"}}.to change(Comment, :count).by(1)
    end
  end
end
