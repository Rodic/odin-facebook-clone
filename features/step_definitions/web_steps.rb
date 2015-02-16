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

When(/^I visit my profile page$/) do
  me = User.find_by_email(FactoryGirl.attributes_for(:user)[:email])
  visit user_path(me)
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


# FILLING

When(/^I fill in "(.*?)" with "(.*?)"$/) do |field, value|
  fill_in field, with: value
end
