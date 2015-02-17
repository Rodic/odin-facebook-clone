require 'rails_helper'

RSpec.describe Like, type: :model do

  describe "validations" do

    it "validates with proper data" do
      expect(FactoryGirl.build(:like)).to be_valid
    end

    it "must has a user" do
      expect(FactoryGirl.build(:like, user_id: nil)).to_not be_valid
    end

    it "must has likable_id" do
      expect(FactoryGirl.build(:like, likeable_id: nil)).to_not be_valid
    end
  end

  
  describe "associations" do

    let(:user)    { FactoryGirl.create(:user) }
    let(:post)    { FactoryGirl.create(:post, user: FactoryGirl.create(:user, email: "poster@odin-facebook.com")) }
    let(:comment) { FactoryGirl.create(:comment, user: FactoryGirl.create(:user, email: "comentator@odin-facebook.com")) }
    let(:like)    { FactoryGirl.create(:like, user: user, likeable: post) }
    let(:like_2)  { FactoryGirl.create(:like, user: user, likeable: comment) }

    it "belongs to user" do
      expect(like).to respond_to(:user)
    end

    it "returns correct user" do
      expect(like.user).to eq(user)
    end

    it "belongs to likeable" do
      expect(like).to respond_to(:likeable)
    end

    it "returns correct likeable" do
      expect(like.likeable).to eq(post)
      expect(like_2.likeable).to eq(comment)
    end
  end

end
