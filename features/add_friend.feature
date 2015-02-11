Feature: Adding friends
  As a user
  So that I can interact with other users
  I want to be able to add them as friends

  Background:
    Given I am registered
    And user "friend@facebook-odin.com" is registered

  Scenario: Send friend request
    When I visit "friend@facebook-odin.com" profile page
    And I follow "Add Friend"
    Then user "friend@facebook-odin.com" should have invite from me
