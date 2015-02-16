Feature: Create post
  As a user
  So that I can share my thoughts with other users
  I want to be able to share posts

  Scenario: Successful post creation from timeline page
    Given I am logged
    When I visit the "timeline" page
    And I fill in "post_content" with "Hello World!"
    And I click "Post!"
    Then I should be on the "timeline" page
    And I should see "Your post has been successfully created"
    And I should see "Hello World!"

  Scenario: Unsuccessful post creation from timeline page
    Given I am logged
    When I visit the "timeline" page
    And I fill in "post_content" with ""
    And I click "Post!"
    Then I should be on the "timeline" page
    And I should see "Post creation failed!"
    
