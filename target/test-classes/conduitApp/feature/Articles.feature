Feature: Tests for Articles

  Background: Define URL
    * def tokenResponse = call read('classpath:helpers/CreateToken.feature')
    * def token = tokenResponse.authToken
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * def articleRequestBody = read('classpath:conduitApp/json/newArticleRequest.json')
    * def randomTitle = dataGenerator.getRandomTitle()
    Given url apiUrl
    Given header Authorization = 'Token ' + token
    Given path 'articles/'

    Scenario: Create new article by read from file
      * set articleRequestBody.article.title = randomTitle
      And request articleRequestBody
      When method post
      Then status 200

  Scenario: Login to account and create article
    * set articleRequestBody.article.title = randomTitle
    And request articleRequestBody
    When method Post
    Then status 200
    * assert response.article.description == 'International news NOW'
    * assert response.article.title == randomTitle

  Scenario: Delete first article in the list
    When method Get
    Then status 200
    * def firstArticle = response.articles[0].slug

    Given header Authorization = 'Token ' + token
    Given path 'articles/',firstArticle
    When method Delete
    Then status 200

  Scenario: Create and Delete Article
    And request {"article":{"tagList":[],"title":"Delete Article","description":"New Article","body":"Nuclears going off "}}
    When method Post
    Then status 200
    * def articleId = response.article.slug

    Given header Authorization = 'Token ' + token
    Given path 'articles/',articleId
    When method Delete
    Then status 200

