Feature: Dashboard

  In order to use Cipele46
  As a user
  I start from browsing the dashboard

  Background:
    Given there are ads
    And I visit the dashboard

  Scenario: Ad filtering for giving
    When I click on giving ads filter
    Then I should see only the giving ads
    When I click on all ads
    Then I should see all ads

  Scenario: Ad filtering for receiving
    When I click on receiving ads filter
    Then I should see only the receiving ads

  Scenario: Ad should have details
    When I click on all ads
    And I click to see the ad details
    Then I should see the ad details

  Scenario: Ad search
    When I enter the search query
    Then I should see only the ads that match the query

  Scenario: Blog
    When I click on the blog
    Then I should see a blog

  Scenario: Our story
    When I click on our story
    Then I should see our story

  Scenario: Ad creation
    When I click on ad creation
    Then I should see a message that I should sign in
