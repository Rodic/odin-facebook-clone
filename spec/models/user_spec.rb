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

    it "has many accepted friendships" do
      expect(user_1).to respond_to(:accepted_friendships)
    end

    it "returns correct values for accepted_friendships" do
      expect(user_1.accepted_friendships).to eq([friendship_3, friendship_4])
    end

    it "has many friendships" do
      expect(user_1).to respond_to(:friendships)
    end

    it "returns correct friendships" do
      expect(user_1.friendships).to eq([friendship_1, friendship_2, friendship_3, friendship_4])
    end

    it "has many initiated_friends" do
      expect(user_1).to respond_to(:initiated_friends)
    end

    it "returns correct initiated_friends" do
      expect(user_1.initiated_friends).to eq([user_2, user_4])
    end

    it "has many accepted_friends" do
      expect(user_1).to respond_to(:accepted_friends)
    end

    it "returns correct accepted_friends" do
      expect(user_1.accepted_friends).to eq([user_3, user_5])
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
  end

  describe "methods" do
    
    let(:user)   { FactoryGirl.create(:user) }
    let(:friend) { FactoryGirl.create(:user, email: "friend@odin-facebook.com") }

    it "has add_friend method" do
      expect(user).to respond_to(:add_friend)
    end

    it "adds correct friends" do
      expect{ user.add_friend(friend) }.to change(Friendship, :count).by(1)
      expect(Friendship.last.user_1).to eq(user)
      expect(Friendship.last.user_2).to eq(friend)
    end
  end
end
