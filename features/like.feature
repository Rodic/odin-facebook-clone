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

  Scenario: Unlike post
    Given I liked post "Unlike me!"
    When I visit "Unlike me!" post page
    And I click "Unlike"
    Then post "Unlike me!" should not have likes

  Scenario: Liking comments
    Given I am logged
    And there is post with content "Like me!"
    And there is comment for post "Like me!" with content "like me too!!!"
    When I visit "Like me!" post page
    When I click "like"
    Then comment "like me too!!!" should have one like from me
    And I should be on the "Like me!" post page

  Scenario: Unlike comment
    Given I liked "unlike me too!!!" comment of "Unlike me" post
    When I visit "Unlike me" post page
    And I click "unlike"
    Then comment "unlike me too!!!" should not have likes
