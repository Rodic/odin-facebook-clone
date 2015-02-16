require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }
  
  describe "index" do
    it "renders correct template" do
      expect(get :index).to render_template("index")
    end
  end

  describe "post" do

    it "redirects to timeline" do
      expect(post :create, post: { content: "Test", user_id: user.id }).to redirect_to(posts_path)
    end

    it "creates new record" do
      expect{post :create, post: { content: "Test", user_id: user.id }}.to change(Post, :count).by(1)
    end
  end
end
