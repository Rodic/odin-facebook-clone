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
    
    let(:post) { FactoryGirl.create(:post) }
    let(:like) { FactoryGirl.create(:like, likeable: post, user_id: 0) }
    
    it "has owner" do
      expect(post).to respond_to(:user)
    end

    it "returns correct owner" do
      expect(post.user).to eq(User.last)
    end

    it "has many comments" do
      expect(post).to respond_to(:comments)
    end

    it "returns correct comments" do
      comment = FactoryGirl.create(:comment, post: post)
      expect(post.comments).to eq([comment])
    end

    it "has many likes" do
      expect(post).to respond_to(:likes)
    end

    it "returns correct likes" do
      expect(post.likes).to eq([like])
    end

    it "has many likers" do
      expect(post).to respond_to(:likers)
    end

    it "returns correct likers" do
      liker_1 = FactoryGirl.create(:user, email: "liker_1@odin-facebook.com")
      liker_2 = FactoryGirl.create(:user, email: "liker_2@odin-facebook.com")

      FactoryGirl.create(:like, user: liker_1, likeable: post)
      FactoryGirl.create(:like, user: liker_2, likeable: post)

      expect(post.likers).to contain_exactly(liker_1, liker_2)
    end
  end

  describe "counter" do

    let(:post) { FactoryGirl.create(:post) }

    it "has likes_counter" do
      expect(post).to respond_to(:likes_counter)
    end

    it "increments when comment is liked" do
      expect(post.likes_counter).to eq(0)
      FactoryGirl.create(:like, likeable: post)
      expect(post.likes_counter).to eq(1)
    end

    it "decreases when comment is unliked" do
      expect(post.likes_counter).to eq(0)
      like = FactoryGirl.create(:like, likeable: post)
      expect(post.likes_counter).to eq(1)

      like.destroy
      expect(post.likes_counter).to eq(0)
    end
  end

  describe "methods" do

    let(:post)       { FactoryGirl.create(:post) }
    let(:liker)      { FactoryGirl.create(:user, email: "liker@odin-facebook.com") }
    let!(:like)      { FactoryGirl.create(:like, user: liker, likeable: post) }
    let(:not_liker)  { FactoryGirl.create(:user, email: "not-liker@odin-facebook.com") }

    it "has liked_by?" do
      expect(post).to respond_to(:liked_by?)
    end

    it "returns correct bool" do
      expect(post.liked_by?(liker)).to be_truthy
      expect(post.liked_by?(not_liker)).to be_falsey
    end
  end
end
