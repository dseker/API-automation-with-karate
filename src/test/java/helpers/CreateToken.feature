Feature: Create Token

  Background:
    Given url 'https://api.realworld.io/api/'

  Scenario: Generate Token
    Given path 'users/login'
    And request {"user": {"email": "karate@test.com","password": "Karate123"}}
    When method Post
    Then status 200
    * def authToken = response.user.token