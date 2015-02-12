Feature: Adding friends
  As a user
  So that I can interact with other users
  I want to be able to add them as friends

  Scenario: Send friend request
    Given I am logged
    And user "friend@odin-facebook.com" is registered
    When I visit "friend@odin-facebook.com" profile page
    And I click "Add Friend"
    Then I should see "You asked friend@odin-facebook.com to be your friend"
    And user "friend@odin-facebook.com" should have invite from me

  Scenario: Accept friend request
    Given I am registered
    And user "friend@odin-facebook.com" is registered
    And "friend@odin-facebook.com" sent friend request to me
    When I log
    And I visit my profile page
    Then I should see "1 friend request"
    When I follow "1 friend request"
    Then I should see "friend@odin-facebook.com"
    When I click "Accept"
    Then user "friend@odin-facebook.com" is among my friends
    And I should see "You are now firend with friend@odin-facebook.com"
