Feature: Ads

  As a user 
  I want to be able to create and edit ads

  Scenario: Ad creation for guests
    When I visit the ad creation page
    Then I should see a message that I should sign in
