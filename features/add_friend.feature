Feature: Adding friends
  As a user
  So that I can interact with other users
  I want to be able to add them as friends

  Background:
    Given I am logged
    And user "friend@odin-facebook.com" is registered

  Scenario: Send friend request
    When I visit "friend@odin-facebook.com" profile page
    And I click "Add Friend"
    Then I should see "You asked friend@odin-facebook.com to be your friend"
    And user "friend@odin-facebook.com" should have invite from me
