Given(/^I am on the "(.*?)" page$/) do |page|
  case page
  when "signup"
    visit signup_path
  else
    raise "Unknown page: #{page}. Implement it in web_steps.rb"
  end
end
