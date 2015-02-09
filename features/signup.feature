Feature: User sign up
  As a user
  So that I can use facebook clone
  I want to be able to sign up

  Scenario: Sign up successfully
    Given I am on the "signup" page
    When I fill in "Email" with default email
    And I fill in "Password" with default password
    And I fill in "Password confirmation" with default password confirmation
    And I click "Sign up"
    Then I should be on the root page
    And I should see "Welcome! You have signed up successfully."

  Scenario: Sign up unsuccessfully
    Given I am on the "signup" page
    When I fill in "Email" with default email
    And I fill in "Password" with default password
    And I fill in "Password confirmation" with "mistake"
    And I click "Sign up"
    Then I should be on the "signup" page
    And I should see "Password confirmation doesn't match Password"
