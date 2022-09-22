Feature: Tests for Articles

  Background: Define URL
    Given url apiUrl
    * def tokenResponse = call read('classpath:helpers/CreateToken.feature')
    * def token = tokenResponse.authToken
    Given header Authorization = 'Token ' + token
    Given path 'articles/'
    * def articleRequestBody = read('classpath:conduitApp/json/newArticleRequest.json')

    Scenario: Create new article by read from file
      And request articleRequestBody
      When method post
      Then status 200

  Scenario: Login to account and create article
    And request {"article":{"tagList":[],"title":"Some news title2","description":"International news NOW","body":"Nuclears going off "}}
    When method Post
    Then status 200
    * assert response.article.description == 'International news NOW'
    * assert response.article.title == 'Some news title2'

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

