FactoryGirl.define do
  factory :comment do
    content "MyText"
    user_id 1
    post_id 1
    likes_counter 0
  end

end
