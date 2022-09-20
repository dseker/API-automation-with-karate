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
    # This match will pass if one or more of the values is in the tags array
    * match response.tags contains any ['welcome', 'dragons', 'fish']
    # Assertion passes ONLY if the provided values are all that contains in the array, no less or more
   # * match response.tags contains only ['']
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
    # Assert objects in the response,
    * match response == {"articles": "#array", "articlesCount": 3}
    #Assert key contains value
    * match response.articles[0].createdAt contains '2021'
    # Loop thru all the objects and find if any username contains value
    * match response.articles[*].author.username contains 'Gerome'
    # Another wildcard to loop thru all 'bio' keys and see if atleast one value contains null
    * match response..bio contains null
    # Verify each key contains expected value
    * match each response..following == false

