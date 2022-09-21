Feature: Signup new user

  Background: Preconditions
    * def dataGenerator = Java.type('helpers.DataGenerator')
    Given url apiUrl+'users'

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

  Scenario: Create a unique user
    * def randomEmail = dataGenerator.getRandomEmail()
    * def randomUsername = dataGenerator.getRandomUsername()

    Given def userData = {"email":"brucelee2355@karate.com","username":"KarateUser1367"}
    And request
    """
         {
           "user": {
              "email": #(randomEmail),
              "password": "Karate123",
              "username": #(randomUsername)
            }
         }
    """
    When method post
    Then status 200
    And match response ==
    """
        {
          "user": {
              "email": #(randomEmail),
              "username": #(randomUsername),
              "bio": null,
              "image": null,
              "token": "#string"
          }
        }
    """

