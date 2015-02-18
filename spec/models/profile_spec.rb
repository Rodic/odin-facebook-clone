require 'rails_helper'

RSpec.describe Profile, type: :model do
  
  describe "validations" do

    it "if specified gender is in 'male', 'female' or 'other'" do
      %w{ Male Female Other }.each do |gender|
        expect(FactoryGirl.build(:profile, gender: gender)).to be_valid
      end
      %w{ male unspecified something }.each do |gender|
        expect(FactoryGirl.build(:profile, gender: gender)).to_not be_valid
      end
    end

    it "if specified age must be positive int less than 121" do
      [ 1, 5, 7, 120 ].each do |age|
        expect(FactoryGirl.build(:profile, age: age)).to be_valid
      end

      [ -5, 0, 121 ].each do |age|
        expect(FactoryGirl.build(:profile, age: age)).to_not be_valid
      end
    end

    it "if specified 'about_me' can be 1k chars long at max" do
      expect(FactoryGirl.build(:profile, about_me: 'a')).to be_valid
      expect(FactoryGirl.build(:profile, about_me: 'a'*1000)).to be_valid
      expect(FactoryGirl.build(:profile, about_me: 'a'*1001)).to_not be_valid
    end
  end

  describe "associations" do
    
    let(:user)    { FactoryGirl.create(:user) }
    let(:profile) { FactoryGirl.create(:profile, user: user) }

    it "belongs to user" do
      expect(profile).to respond_to(:user)
    end

    it "returns correct user" do
      expect(profile.user).to eq(user)
    end
  end
end
