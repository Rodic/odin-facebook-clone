Feature: Add comment to a post
  As a user
  So that I can enjoy disccussions with other users
  I want to be able to post comments on their posts

  Scenario: Successful commenting
    Given I am logged
    And there is post with content "Hello World!"
    When I visit "Hello World!" post page
    And I fill in "comment_content" with "...from the odin-facebook.com"
    And I click "Add comment"
    Then I should be on the "Hello World!" post page
    And I should see "Comment added successfully!"
    And I should see "...from the odin-facebook.com"

  Scenario: Unsuccessful commenting
    Given I am logged
    And there is post with content "Hello World!"
    When I visit "Hello World!" post page
    And I fill in "comment_content" with ""
    And I click "Add comment"
    Then I should be on the "Hello World!" post page
    And I should see "Faild to post comment!"
