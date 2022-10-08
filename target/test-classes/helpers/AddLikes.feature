Feature: Favorites Likes

  Background:
    Given url apiUrl
    * def slug = 'Consider-Phlebas-644/favorite'
    * def tokenResponse = call read('classpath:helpers/CreateToken.feature')
    * def token = tokenResponse.authToken



    Scenario: add likes
      Given path 'articles/', slug
      Given header Authorization = 'Token ' + token
      And request {}
      When method post
      Then status 200
      * def likesCount = response.article.favoritesCount
      * print 'Reached AddLikes.feature'

