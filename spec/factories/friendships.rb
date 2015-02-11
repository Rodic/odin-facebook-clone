FactoryGirl.define do
  factory :friendship do
    user_1_id 1
    user_2_id 2
    user_1_status "active"
    user_2_status "pending"
  end

end
