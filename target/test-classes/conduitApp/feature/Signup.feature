Feature: Signup new user

  Background: Preconditions
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

    Given def userData = {"email":"brucelee2355@karate.com","username":"KarateUser1367"}
    And request
    """
         {
           "user": {
              "email": #('Test'+userData.email),
              "password": "Karate123",
              "username": #('Test'+userData.username)
            }
         }
    """
    When method post
    Then status 200

