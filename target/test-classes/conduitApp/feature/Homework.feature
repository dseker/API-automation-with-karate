Feature: Homework assignment

  Background:
    Given url apiUrl
    * def tokenResponse = call read('classpath:helpers/CreateToken.feature')
    * def token = tokenResponse.authToken
    * def commentsResponseBody = read('classpath:conduitApp/json/getCommentsResponse.json')
    Given header Authorization = 'Token ' + token
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * def GOTquotes = dataGenerator.getGameOfThronesQuotes()


  Scenario: Favorite articles
    Given path 'articles/Create-a-new-implementation-1/favorite'
    When method delete
    Then status 200

    Given path 'articles'
    When method get
    Then status 200
    * def myFavoritesCount = response.articles[0].favoritesCount
    * def firstArticleSlugID = response.articles[0].slug
    * print('Favorites count ' + myFavoritesCount + '\n Article Slug id: ' + firstArticleSlugID)

    Given path 'articles/Create-a-new-implementation-1/favorite'
    Given header Authorization = 'Token ' + token
    When method post
    Then status 200
    * print(response.article.favoritesCount)
    * match response.article.favoritesCount == myFavoritesCount + 1

  Scenario: Get all favorite articles count
    Given path 'articles'
    When method get
    * def favoriteArticlesCountArray = []
        # * def myFunction = function(i){return print(response.articles[i].favoritesCount)}
        # * def foo = karate.repeat(3, myFunction)
    * def myFun1 = function(i){karate.appendTo(favoriteArticlesCountArray, response.articles[i].favoritesCount)}
    * karate.repeat(3, myFun1)
    * print(favoriteArticlesCountArray)

    * def favoriteOccurrence = $..favoritesCount
    * def slugIDsArray = []
    * def myFun2 = function(i){karate.appendTo(slugIDsArray, response.articles[i].slug)}
    * karate.repeat(favoriteOccurrence.length, myFun2)
    * match slugIDsArray[*] contains response.articles[0].slug


  Scenario: Comment articles
    # Get articles
    Given path 'articles'
    When method get
    Then status 200

    # Get comments array and store length
    Given path 'articles/Create-a-new-implementation-1/comments'
    Given header Authorization = 'Token ' + token
    When method get
    Then status 200
    * def commentsLength = response.comments.length

    #Make a post request to publish new comment
    Given path '/articles/Create-a-new-implementation-1/comments'
    Given header Authorization = 'Token ' + token
    And request {"comment":{"body":#(GOTquotes)}}
    When method post
    Then status 200
    * match response..body contains '#(GOTquotes)'

    # Get all comments and verify comments array length aggregated by 1
    Given path '/articles/Create-a-new-implementation-1/comments'
    Given header Authorization = 'Token ' + token
    When method get
    Then status 200
    * def updatedCommentsLength = response.comments.length
    * def bodyOfLastIndex = response.comments[updatedCommentsLength -1].body
    * def idOfLastIndexComment = response.comments[updatedCommentsLength - 1].id
    * assert commentsLength == response.comments.length - 1
    * print('Body of last index' + bodyOfLastIndex)

    # Delete comment with id of the last index of the comments Array
    Given path 'articles/Create-a-new-implementation-1/comments/' + idOfLastIndexComment
    Given header Authorization = 'Token ' + token
    When method delete
    Then status 200

    # Validate array size decreased by 1 after delete request
    Given path '/articles/Create-a-new-implementation-1/comments'
    Given header Authorization = 'Token ' + token
    When method get
    * def updatedCommentsLength = updatedCommentsLength - 1
    * assert commentsLength == updatedCommentsLength
    
    * print('Text printed ' + bodyOfLastIndex)









