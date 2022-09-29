Feature: Signup new user

  Background: Preconditions
    Given url apiUrl+'users'
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * def randomEmail = dataGenerator.getRandomEmail()
    * def randomUsername = dataGenerator.getRandomUsername()

  Scenario: Create an already existing User
    And request
    """
         {
           "user":{
             "email":"brucelee100@karate.com",
              "password":"Karate123",
              "username":"KarateUser166"
            }
         }
    """
    When method post
    Then status 422
    * print(response.errors.email)
    * assert response.errors.email[0] == "has already been taken"
    * assert response.errors.username[0] == "has already been taken"


 # Data-driven Example
  Scenario Outline: Data-driven signup
    Given def userData = {"email":"brucelee2355@karate.com","username":"KarateUser1367"}
    And request
    """
         {
           "user": {
              "email": "<email>",
              "password": "<password>",
              "username": "<username>"
            }
         }
    """
    When method post
    Then status <statusCode>
    * print(response)
    And match response == <errorResponse>
    Examples:
      | email                | password   | username          | statusCode | errorResponse                                      |
      | #(randomEmail)       | Karate1234 | KaratUser123      | 422        | {"errors":{"username":["has already been taken"]}}
      | KarateUser1@test.com | Karate1234 | #(randomUsername) | 422        | {"errors":{"email":["has already been taken"]}}
      | #(randomEmail)       | Karate1234 | #(randomUsername) | 200        | {"user":{"email":#(randomEmail),"username":#(randomUsername),"bio":null,"image":"##string","token":"#string"}}
