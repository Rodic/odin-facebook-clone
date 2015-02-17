Feature: Liking
  As a user
  So that I can express my thoughts about certain posts or comments
  I want to be able to like them

  Scenario: Liking posts
    Given I am logged
    And there is post with content "Like me!"
    When I visit "Like me!" post page
    When I follow "Like"
    Then post "Like me!" should have one like from me
