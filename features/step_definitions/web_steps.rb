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
  else
    raise "Unknown page: #{page}. Implement it in web_steps.rb"
  end
end

When(/^I visit "(.*?)" profile page$/) do |email|
  visit user_path(User.find_by_email(email))
end


# DEFAULT USER

Given(/^I am registered$/) do
  FactoryGirl.create(:user)
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


# OTHER USERS

Given(/^user "(.*?)" is registered$/) do |email|
  FactoryGirl.create(:user, email: email)
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
  expect(User.find_by_email(email).invites.count).to eq(1)
end



# FILLING

When(/^I fill in "(.*?)" with "(.*?)"$/) do |field, value|
  fill_in field, with: value
end
