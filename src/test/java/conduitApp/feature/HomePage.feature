Feature: Tests for the HomePage

  Background: Define URL
    Given url apiUrl

  Scenario: Get all tags
    Given path 'tags'
    When method Get
    Then status 200
    * assert response.tags[0] == 'implementations'
    * match response.tags contains ['welcome', 'introduction']
    * match response.tags !contains ['trucks']
    * match response.tags == "#array"
    * match each response.tags == "#string"
    * def firstTag = response.tags[0]
    * print("First tag in the list: " + firstTag)

  Scenario: Get 10 articles from the page
#    Given param limit = 10
#    Given param offset = 0
    Given params {limit: 10, offset: 0}
    Given path 'articles'
    When method Get
    Then status 200
    * assert response.articles[0].slug == 'Create-a-new-implementation-1'
    * match response.articles == '#[3]'
    * assert response.articles[0].title == 'Create a new implementation'
    And print("Yaay")

