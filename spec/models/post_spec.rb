require 'rails_helper'

RSpec.describe Post, type: :model do
  
  describe "validations" do
    it "validates with proper params" do
      expect(FactoryGirl.build(:post)).to be_valid
    end

    it "fails to validate without content" do
      expect(FactoryGirl.build(:post, content: "")).to_not be_valid
    end

    it "fails to validate without user" do
      expect(FactoryGirl.build(:post, user_id: nil)).to_not be_valid
    end
  end

  describe "associations" do
    it "has owner" do
      expect(FactoryGirl.create(:post)).to respond_to(:user)
    end

    it "returns correct owner" do
      expect(FactoryGirl.create(:post).user).to eq(User.last)
    end
  end
end
