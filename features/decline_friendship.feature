Feature: Decline friendship
  As a user
  So that I can choose who I'm friend with
  I want to be able to decline friendship request

  Scenario: Decline friendship request
    Given I am registered
    And user "friend@odin-facebook.com" is registered
    And "friend@odin-facebook.com" sent friend request to me
    When I log
    And I visit my profile page
    Then I should see "1 friend request"
    When I follow "1 friend request"
    Then I should see "friend@odin-facebook.com"
    When I click "Decline"
    Then my request box should be empty
    And I should see "Friendship has been canceld"
