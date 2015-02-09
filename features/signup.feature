Feature: User sign up
  As a user
  So that I can use facebook clone
  I want to be able to sign up

  Scenario: Sign up successfully
    Given I am on the "signup" page
    When I fill in "Email" with default email
    And I fill in "Password" with default password
    And I fill in "Password confirmation" with default password
    And I click "Submit"
    Then I should be on the "default user" page
    And I should see "Your account has been created successfully"

  Scenario: Sign up unsuccessfully
    Given I am on the "sginup" page
    When I fill in "Email" with default email
    And I fill in "Password" with default password
    And I fill in "Password confirmation" with "mistake"
    And I click "Submit"
    Then I should be on the "signup" page
    And I should see "Invalid passwords"
