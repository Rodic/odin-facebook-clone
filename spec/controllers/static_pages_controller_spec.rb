require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do

  describe "GET #about" do

    context "when signed in" do

      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it "returns http success" do
        get :about
        expect(response).to have_http_status(:success)
      end
    end

    context "when signed out" do
      it "redirects to sign in page" do
        expect(get :about).to redirect_to(new_user_session_path)
      end
    end 
  end
end
