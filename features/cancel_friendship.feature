Feature: Cancel friendship
  As a user
  So that I'm not bother with people I don't like anymore
  I want to be able to cancel friendship

  Scenario: Press "Cancel Friendship" button on user profile
    Given I am logged
    And user "friend@odin-facebook.com" and I are friends
    When I visit "friend@odin-facebook.com" profile page
    And I click "Cancel Friendship"
    Then I should see "Friendship has been canceld"
    And I should not be friend with "friend@odin-facebook.com"
