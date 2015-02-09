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
end
