require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }
  
  describe "index" do
    it "renders correct template" do
      expect(get :index).to render_template("index")
    end
  end
end
