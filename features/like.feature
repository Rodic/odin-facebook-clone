Feature: Liking
  As a user
  So that I can express my thoughts about certain posts or comments
  I want to be able to like them

  Scenario: Liking posts
    Given I am logged
    And there is post with content "Like me!"
    When I visit "Like me!" post page
    When I click "Like"
    Then post "Like me!" should have one like from me
    And I should be on the "Like me!" post page

  Scenario: Liking comments
    Given I am logged
    And there is post with content "Like me!"
    And there is comment for post "Like me!" with content "like me too!!!"
    When I visit "Like me!" post page
    When I click "like"
    Then comment "like me too!!!" should have one like from me
    And I should be on the "Like me!" post page
