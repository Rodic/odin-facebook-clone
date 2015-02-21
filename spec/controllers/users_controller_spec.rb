require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "show" do

    let(:user) { FactoryGirl.create(:user) }

    context "when signed in" do

      before { sign_in user }

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

    context "when signed out" do
      it "redirects to sign in page" do
        expect(get :show, id: user.id).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "index" do

    let(:user) { FactoryGirl.create(:user) }
    before { sign_in user }

    it "renders correct template" do
      expect(get :index).to render_template('index')
    end
  end
end
