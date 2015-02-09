Feature: User signin
  As a user
  So that I can use facebook clone
  I want to be able to signin

  Background:
    Given I am registered

  Scenario: Successfull signin
    Given I am on the "signin" page
    When I fill in "Email" with default email
    And I fill in "Password" with default password
    And I click "Sign in"
    Then I should be on the root page
    And I should see "Signed in successfully."


  Scenario: Unsuccessful signin
    Given I am on the "signin" page
    When I fill in "Email" with default email
    And I fill in "Password" with "wrongpassword"
    And I click "Sign in"
    Then I should be on the "signin" page
    And I should see "Invalid email or password."
