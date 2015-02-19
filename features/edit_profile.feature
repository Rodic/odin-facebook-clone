Feature: Edit profile
  As a user
  So that I can express who I am
  I want to be able to share infos about myself with other users

  Scenario: Edit profile
    Given I am logged
    And I am on my profile page
    When I follow "Edit profile"
    And I fill in "About me" with "Aspiring rails dev"
    And I select "Male" for "Gender"
    And I select "31" for "Age"
    And I fill in "City" with "Belgrade"
    And I fill in "Country" with "Serbia"
    And I fill in "Work" with "Freelancing on Elance"
    And I fill in "Website" with "www.website.me"
    And I click "Update"
    Then I should be on my profile page
    And I should see "Your profile has been updated successfully"
    And I should see "Aspiring rails dev"
    And I should see "Male"
    And I should see "31"
    And I should see "Belgrade"
    And I should see "Serbia"
    And I should see "Freelancing on Elance"
    And I should see "www.website.me"
