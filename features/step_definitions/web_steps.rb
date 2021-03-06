# VISITING/ASSERTING PAGES

Given(/^I am on the "(.*?)" page$/) do |page|
  case page
  when "signup"
    visit new_user_registration_path
  when "signin"
    visit new_user_session_path
  else
    raise "Unknown page: #{page}. Implement it in web_steps.rb"
  end
end

Then(/^I should be on the root page$/) do
  expect(page.current_path).to eq(root_path)
end

Then(/^I should be on the "(.*?)" page$/) do |pg|
  case pg
  when "signup"
    expect(page.current_path).to eq(new_user_registration_path)
  when "signin"
    expect(page.current_path).to eq(new_user_session_path)
  when "timeline"
    expect(page.current_path).to eq(posts_path)
  else
    raise "Unknown page: #{page}. Implement it in web_steps.rb"
  end
end

When(/^I visit the "(.*?)" page$/) do |page|
  case page
  when "timeline"
    visit posts_path
  else
    raise "Unknown page: #{page}: Implement it in web_steps.rb"
  end
end

When(/^I visit "(.*?)" profile page$/) do |email|
  visit user_path(User.find_by_email(email))
end

When(/^I visit "(.*?)" post page$/) do |content|
  visit post_path(Post.find_by_content(content))
end

When(/^I visit my profile page$/) do
  me = User.find_by_email(FactoryGirl.attributes_for(:user)[:email])
  visit user_path(me)
end

Given(/^I am on my profile page$/) do
 step "I visit my profile page" 
end

Then(/^I should be on the "(.*?)" post page$/) do |content|
  expect(page.current_path).to eq(post_path(Post.find_by_content(content)))
end

Then(/^I should be on the "(.*?)" comment page$/) do |content|
  expect(page.current_path).to eq(post_comments_path(Post.find_by_content(content)))
end

Then(/^I should be on my profile page$/) do
  me = User.find_by_email(FactoryGirl.attributes_for(:user)[:email])
  expect(page.current_path).to eq(user_path(me))
end


# DEFAULT USER

Given(/^I am registered$/) do
  FactoryGirl.create(:user)
end

When(/^I log$/) do
  attrs = FactoryGirl.attributes_for(:user)
  visit new_user_session_path
  fill_in "Email",    with: attrs[:email]
  fill_in "Password", with: attrs[:password]
  click_button 'Sign in'
end

Given(/^I am logged$/) do
  step "I am registered"
  step "I log"
end

When(/^I fill in "(.*?)" with default email$/) do |field|
  fill_in field, with: FactoryGirl.attributes_for(:user)[:email]
end

When(/^I fill in "(.*?)" with default password$/) do |field|
  fill_in field, with: FactoryGirl.attributes_for(:user)[:password]
end

When(/^I fill in "(.*?)" with default password confirmation$/) do |field|
  fill_in field, with: FactoryGirl.attributes_for(:user)[:password_confirmation]
end

Then(/^user "(.*?)" is among my friends$/) do |email|
  expect(User.find_by_email(FactoryGirl.attributes_for(:user)[:email]).friends).to include(User.find_by_email(email))
end

Then(/^my request box should be empty$/) do
  expect(User.find_by_email(FactoryGirl.attributes_for(:user)[:email]).friend_requests).to be_empty
end

Given(/^user "(.*?)" and I are friends$/) do |email|
  me = User.find_by_email(FactoryGirl.attributes_for(:user)[:email])
  friend = FactoryGirl.create(:user, email: email)
  FactoryGirl.create(:friendship, user_1: me, user_2: friend, user_2_status: 'active')
end

Then(/^I should not be friend with "(.*?)"$/) do |email|
  me = User.find_by_email(FactoryGirl.attributes_for(:user)[:email])
  friend = User.find_by_email(email)
  expect(me.friend?(friend)).to be_falsey
end

Given(/^there is post with content "(.*?)"$/) do |content|
  me = User.find_by_email(FactoryGirl.attributes_for(:user)[:email])
  FactoryGirl.create(:post, content: content, user: me)
end

Given(/^there is comment for post "(.*?)" with content "(.*?)"$/) do |post_content, comment_content|
  me = User.find_by_email(FactoryGirl.attributes_for(:user)[:email])
  post = Post.find_by_content(post_content)
  FactoryGirl.create(:comment, user: me, post: post, content: comment_content)
end

Then(/^post "(.*?)" should have one like from me$/) do |content|
  me = User.find_by_email(FactoryGirl.attributes_for(:user)[:email])
  likes = Post.find_by_content(content).likes 
  expect(likes.count).to eq(1)
  expect(likes.last.user).to eq(me)
end

Then(/^comment "(.*?)" should have one like from me$/) do |content|
  me = User.find_by_email(FactoryGirl.attributes_for(:user)[:email])
  comment = Comment.find_by_content(content)
  expect(comment.likes.count).to eq(1)
  expect(comment.likes.last.user).to eq(me)
end

Given(/^I liked post "(.*?)"$/) do |content|
  step 'I am logged'
  step "there is post with content \"#{content}\""
  step "I visit \"#{content}\" post page"
  step 'I click "Like"'
end

Then(/^post "(.*?)" should not have likes$/) do |content|
  expect(Post.find_by_content(content).likes.count).to eq(0)
end

Given(/^I liked "(.*?)" comment of "(.*?)" post$/) do |comment_content, post_content|
  step 'I am logged'
  step "there is post with content \"#{post_content}\""
  step "there is comment for post \"#{post_content}\" with content \"#{comment_content}\""
  step "I visit \"#{post_content}\" post page"
  step 'I click "like"'
end

Then(/^comment "(.*?)" should not have likes$/) do |content|
  expect(Comment.find_by_content(content).likes.count).to eq(0)
end



# OTHER USERS

Given(/^user "(.*?)" is registered$/) do |email|
  FactoryGirl.create(:user, email: email)
end

Given(/^"(.*?)" sent friend request to me$/) do |email|
  other = User.find_by_email(email)
  me    = User.find_by_email(FactoryGirl.attributes_for(:user)[:email])
  other.add_friend(me)
end


# CLICKING

When(/^I click "(.*?)"$/) do |btn|
  click_button btn
end

When(/^I follow "(.*?)"$/) do |link|
  click_link link
end


# MATCHING CONTENT / ASSERTING

Then(/^I should see "(.*?)"$/) do |msg|
  expect(page).to have_content(msg)
end

Then(/^user "(.*?)" should have invite from me$/) do |email|
  expect(User.find_by_email(email).friend_requests.count).to eq(1)
end


# FILLING/SELECTING

When(/^I fill in "(.*?)" with "(.*?)"$/) do |field, value|
  fill_in field, with: value
end

When(/^I select "(.*?)" for "(.*?)"$/) do |value, option|
  select value, from: option
end
