require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "show" do

    let(:user) { FactoryGirl.create(:user) }

    it "returns http success" do
      get :show, id: user.id
      expect(response).to have_http_status(:success)
    end

    it "renders correct template" do
      expect(get :show, id: user.id).to render_template('show')
    end

    it "provides user to the view" do
      get :show, id: user.id
      expect(assigns(:user)).to eq(user)
    end
  end
end
