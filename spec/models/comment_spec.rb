require 'rails_helper'

RSpec.describe Comment, type: :model do
  
  describe "validations" do

    it "validates with proper params" do
      expect(FactoryGirl.build(:comment)).to be_valid
    end

    it "fails to validate without content" do
      expect(FactoryGirl.build(:comment, content: nil)).to_not be_valid
    end

    it "fails when content is longer than 1k chars" do
      expect(FactoryGirl.build(:comment, content: 'a'*1001)).to_not be_valid
    end

    it "fails to validate without author" do
      expect(FactoryGirl.build(:comment, user_id: nil)).to_not be_valid
    end

    it "fails to validate without post" do
      expect(FactoryGirl.build(:comment, post_id: nil)).to_not be_valid
    end
  end

  describe "associations" do

    let(:post)    { FactoryGirl.create(:post) }
    let(:user)    { FactoryGirl.create(:user, email: "comment-poster@odin-facebook.com") }
    let(:comment) { FactoryGirl.create(:comment, user: user, post: post) }

    it "belongs to user" do
      expect(comment).to respond_to(:user)
    end

    it "returns correct user" do
      expect(comment.user).to eq(user)
    end

    it "belongs to post" do
      expect(comment).to respond_to(:post)
    end

    it "returns correct post" do
      expect(comment.post).to eq(post)
    end
  end
end
