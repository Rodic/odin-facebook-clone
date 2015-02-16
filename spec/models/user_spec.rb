require 'rails_helper'

RSpec.describe User, type: :model do
  
  describe "validations" do

    it { expect(FactoryGirl.build(:user)).to be_valid }
    
    describe "password" do

      it "cannot be blank" do
        expect(FactoryGirl.build(:user, password: nil, password_confirmation: nil)).to_not be_valid
      end

      it "must match confirmation" do
        expect(FactoryGirl.build(:user, password: "not-confirmation")).to_not be_valid
        expect(FactoryGirl.build(:user, password_confirmation: "not-orig")).to_not be_valid
      end

      it "must be between 8 and 50 chars long" do
        expect(FactoryGirl.build(:user, password: "#{'a'*7}", 
                                        password_confirmation: "#{'a'*7}")).to_not be_valid
        expect(FactoryGirl.build(:user, password: "#{'a'*51}", 
                                        password_confirmation: "#{'a'*51}")).to_not be_valid
      end
    end

    describe "email" do

      it "cannot be blank" do
        expect(FactoryGirl.build(:user, email: nil)).to_not be_valid
      end

      it "fails to validate when form is invalid" do
        ems = [
               "invalid",
               "invalid@with-at",
               "invalid@with@multiple-at"
              ]

        ems.each do |e|
          expect(FactoryGirl.build(:user, email: e)).to_not be_valid
        end
      end

      it "validates when form is valid" do
        ems = [
               "valid@email.com",
               "valid@with-hypen.org",
               "first.last@name.com" 
              ]

        ems.each do |e|
          expect(FactoryGirl.build(:user, email: e)).to be_valid
        end
      end

      it "fails to validate when length is greater than 50 chars" do
        expect(FactoryGirl.build(:user, email: "tes#{'t'*50}@facebook-clone.com")).to_not be_valid
      end
    end
  end

  describe "associations" do

    let(:user_1) { FactoryGirl.create(:user, email: 'test1@facebook-odin.com') }
    let(:user_2) { FactoryGirl.create(:user, email: 'test2@facebook-odin.com') }
    let(:user_3) { FactoryGirl.create(:user, email: 'test3@facebook-odin.com') }
    let(:user_4) { FactoryGirl.create(:user, email: 'test4@facebook-odin.com') }
    let(:user_5) { FactoryGirl.create(:user, email: 'test5@facebook-odin.com') }
    let!(:friendship_1) { FactoryGirl.create(:friendship, user_1: user_1, user_2: user_2) }
    let!(:friendship_2) { FactoryGirl.create(:friendship, user_1: user_1, user_2: user_4, user_2_status: "pending") }
    let!(:friendship_3) { FactoryGirl.create(:friendship, user_1: user_3, user_2: user_1) }
    let!(:friendship_4) { FactoryGirl.create(:friendship, user_1: user_5, user_2: user_1, user_2_status: "pending") }
    let!(:friendship_5) { FactoryGirl.create(:friendship, user_1: user_2, user_2: user_3) }
    let!(:friendship_6) { FactoryGirl.create(:friendship, user_1: user_5, user_2: user_2) }

    
    it "has many initiated_friendships" do
      expect(user_1).to respond_to(:initiated_friendships)
    end

    it "returns correct values for initiated_friendships" do
      expect(user_1.initiated_friendships).to eq([friendship_1, friendship_2])
    end

    it "has many friendships_invited_to" do
      expect(user_1).to respond_to(:friendships_invited_to)
    end

    it "returns correct values for friendships_invited_to" do
      expect(user_1.friendships_invited_to).to eq([friendship_3, friendship_4])
    end

    it "has many friendships" do
      expect(user_1).to respond_to(:friendships)
    end

    it "returns correct friendships" do
      expect(user_1.friendships).to eq([friendship_1, friendship_2, friendship_3, friendship_4])
    end

    it "has many invited_users" do
      expect(user_1).to respond_to(:invited_users)
    end

    it "returns correct invited_users" do
      expect(user_1.invited_users).to eq([user_2, user_4])
    end

    it "has many users_invited_by" do
      expect(user_1).to respond_to(:users_invited_by)
    end

    it "returns correct users_invited_by" do
      expect(user_1.users_invited_by).to eq([user_3, user_5])
    end

    it "has many firends" do
      expect(user_1).to respond_to(:friends)
    end

    it "returns correct friends" do
      expect(user_1.friends).to contain_exactly(user_2, user_3)
    end

    it "has friend_requests" do
      expect(user_1).to respond_to(:friend_requests)
    end

    it "returns correct friend_requests" do
      expect(user_1.friend_requests).to eq([friendship_4])
    end

    it "has sent_requests" do
      expect(user_1).to respond_to(:sent_requests)
    end

    it "returns correct sent_requests" do
      expect(user_1.sent_requests).to eq([friendship_2])
    end

    it "has posts" do
      expect(user_1).to respond_to(:posts)
    end

    it "returns correct posts" do
      user_1.posts << FactoryGirl.create(:post)
      expect(user_1.posts).to eq([Post.last])
    end

    it "has many comments" do
      expect(user_1).to respond_to(:comments)
    end

    it "returns correct comments" do
      comment = FactoryGirl.create(:comment, user: user_1)
      expect(user_1.comments).to eq([comment])
    end
  end

  describe "methods" do
    
    let(:user)       { FactoryGirl.create(:user) }
    let(:friend)     { FactoryGirl.create(:user, email: "friend@odin-facebook.com") }

    it "has add_friend method" do
      expect(user).to respond_to(:add_friend)
    end

    it "adds correct friends" do
      expect{ user.add_friend(friend) }.to change(Friendship, :count).by(1)
      expect(Friendship.last.user_1).to eq(user)
      expect(Friendship.last.user_2).to eq(friend)
    end

    it "can determine is friend of other user" do
      FactoryGirl.create(:friendship, user_1: user, user_2: friend)
      user_3 = FactoryGirl.create(:user, email: "not-friend@odin-facebook.com")
      expect(user.friend?(friend)).to be_truthy
      expect(friend.friend?(user)).to be_truthy
      expect(user.friend?(user_3)).to be_falsey
      expect(user_3.friend?(friend)).to be_falsey
    end

    it "can determine if other user is addable" do
      FactoryGirl.create(:friendship, user_1: user, user_2: friend)
      user_3 = FactoryGirl.create(:user, email: "not-friend@odin-facebook.com")
      expect(user.addable?(user)).to be_falsey
      expect(friend.addable?(user)).to be_falsey
      expect(user.addable?(user_3)).to be_truthy
      expect(user_3.addable?(friend)).to be_truthy
    end

    it "has timeline" do
      expect(user).to respond_to(:timeline)
    end

    it "returns correct posts" do
      user = FactoryGirl.create(:user)

      p0 = FactoryGirl.create(:post, content: "newest post", user: user, created_at: 1.minute.ago)

      friend_1 = FactoryGirl.create(:user, email: 'firend1@odin-facebook.com')
      p1 = FactoryGirl.create(:post, content: "new post", user: friend_1, created_at: 1.hour.ago)
      p2 = FactoryGirl.create(:post, content: "very old post", user: friend_1, created_at: 1.week.ago)
      
      friend_2 = FactoryGirl.create(:user, email: 'friend2@odin-facebook.com')
      p3 = FactoryGirl.create(:post, content: "older post", user: friend_2, created_at: 1.day.ago)

      not_friend = FactoryGirl.create(:user, email: 'not@odin-facebook.com')
      p4 = FactoryGirl.create(:post, content: "test", user: not_friend, created_at: 2.days.ago)

      FactoryGirl.create(:friendship, user_1: user, user_2: friend_1)
      FactoryGirl.create(:friendship, user_1: user, user_2: friend_2)

      expect(user.friends).to contain_exactly(friend_1, friend_2)

      expect(user.timeline).to eq([p0, p1, p3, p2])
    end
  end
end
