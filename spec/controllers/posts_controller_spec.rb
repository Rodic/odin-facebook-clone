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

  describe "show" do

    let(:post) { FactoryGirl.create(:post, user: user) }

    it "renders correct template" do
      expect(get :show, id: post.id).to render_template("show")
    end

    it "provides correct val for instance var" do
      get :show, id: post.id
      expect(assigns(:post)).to eq(post)
    end
  end
end
