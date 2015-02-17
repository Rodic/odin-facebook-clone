require 'rails_helper'

RSpec.describe LikesController, type: :controller do

  describe "create" do

    let(:user) { FactoryGirl.create(:user) }
    let(:p)    { FactoryGirl.create(:post, user: user) }
    let(:c)    { FactoryGirl.create(:comment, post: p, user: user) }
    
    before { 
      sign_in user
      request.env["HTTP_REFERER"] = root_path # create redirects to - :back
    }

    it "creates new like for post" do
      expect{ post :create, post_id: p.id  }.to change(Like, :count).by(1) 
    end

    it "creates new like for comment" do
      expect{ post :create, comment_id: c.id }.to change(Like, :count).by(1) 
    end
  end

end
