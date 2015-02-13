require 'rails_helper'

RSpec.describe Friendship, type: :model do
  
  describe "validations" do

    it "validates friendship with proper data" do
      expect(FactoryGirl.build(:friendship)).to be_valid
    end

    it "fails to validate without friends" do
      expect(FactoryGirl.build(:friendship, user_1_id: nil)).to_not be_valid
      expect(FactoryGirl.build(:friendship, user_2_id: nil)).to_not be_valid
      expect(FactoryGirl.build(:friendship, user_1_id: nil, user_2_id: nil)).to_not be_valid
    end
    
    it "fails to validate when status is not in [ 'active', 'pending', 'blocking' ]" do
      [ 'test', '', nil ].each do |status|
        expect(FactoryGirl.build(:friendship, user_1_status: status)).to_not be_valid
        expect(FactoryGirl.build(:friendship, user_2_status: status)).to_not be_valid
      end
    end

    it "validates when status is in [ 'active', 'pending', 'blocking' ]" do
      [ 'active', 'pending', 'blocking' ].each do |status|
        expect(FactoryGirl.build(:friendship, user_1_status: status)).to be_valid
        expect(FactoryGirl.build(:friendship, user_2_status: status)).to be_valid
      end
    end

    it "fails to add friendship if it is already in db" do
      FactoryGirl.create(:friendship)
      expect{ FactoryGirl.create(:friendship) }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it "fails to add inverse friendship if it is already in db" do
      u1 = FactoryGirl.create(:user)
      u2 = FactoryGirl.create(:user, email: "user2@odin-facebook.com")
      f = FactoryGirl.create(:friendship, user_1: u1, user_2: u2)
      expect{ FactoryGirl.create(:friendship, user_1: u2, user_2: u1) }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  describe "associations" do

    let(:user_1) { FactoryGirl.create(:user, email: 'test1@facebook-clone.com') }
    let(:user_2) { FactoryGirl.create(:user, email: 'test2@facebook-clone.com') }
    let(:friendship) { FactoryGirl.create(:friendship, user_1: user_1, user_2: user_2) }

    it "responds to user_id" do
      expect(friendship).to respond_to(:user_1)
      expect(friendship).to respond_to(:user_2)
    end

    it "returns correct user" do
      expect(friendship.user_1).to eq(user_1)
      expect(friendship.user_2).to eq(user_2)
    end
  end
end
