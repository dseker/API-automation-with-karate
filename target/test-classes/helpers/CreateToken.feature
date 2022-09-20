Feature: Create Token

  Background:
    Given url apiUrl

  Scenario: Generate Token
    Given path 'users/login'
    And request {"user": {"email": "#(userEmails)","password": "#(userPassword)"}}
    When method Post
    Then status 200
    * def authToken = response.user.token