Feature: Tests for the HomePage

  Background: Define URL
    Given url apiUrl
    * def timeValidator = read('classpath:helpers/timeValidator.js')

  Scenario: Get all tags
    Given path 'tags'
    When method Get
    Then status 200
    * assert response.tags[0] == 'implementations'
    * match response.tags contains ['welcome', 'introduction']
    * match response.tags !contains ['trucks']
    # Assert response is of Array type
    * match response.tags == "#array"

    # Assert response is of String type
    * match each response.tags == "#string"

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
    # Loop and Verify each key contains expected value
    * match each response..following == false

    # FUZZY MATCHING RESPONSE TYPES

    # Loop and assert each key is a boolean
    * match each response..following == '#boolean'
    # Loop and Verify each value is a number
    * match each response..favoritesCount == '#number'
    # Loop and Verify each value is either a string or null, double ## also mean its optional if the key exists or not
    # this will basically always pass - not recommended
    * match each response..bio == '##string'

    # Schema validation
    * match each response.articles ==
    """
          {
              "slug": "#string",
              "title": "#string",
              "description": "#string",
              "body": "#string",
              "tagList": "#array",
              "createdAt": "#? timeValidator(_)",
              "updatedAt": "#? timeValidator(_)",
              "favorited": "#boolean",
              "favoritesCount": "#number",
              "author": {
                 "username": "#string",
                 "bio": "##string",
                 "image": "#string",
                 "following": "#boolean"
              }
          }
    """

  Scenario: Conditiona logic
    Given path 'articles/Consider-Phlebas-644/'
    When method Get
    Then status 200
    * def favoritesCount = response.article.favoritesCount

    # if favoritesCount equals 0, then call AddLikes.feature and return likesCount variable, otherwise assign favoritesCount to Results var
    * def result = favoritesCount == 0 ? karate.call('classpath:helpers/AddLikes.feature').likesCount : favoritesCount

    # Other type of conditional logic in Karate
    #* if (favoritesCount == 0) karate.call('classpath:helpers/AddLikes.feature')

    Given path 'articles/Consider-Phlebas-644/'
    When method Get
    Then status 200
    * print 'Response favoritesCount: ' + response.article.favoritesCount
    And match response.article.favoritesCount == result

