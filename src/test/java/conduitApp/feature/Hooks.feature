Feature: Hooks


  Background: before hooks
    * def result = callonce read('classpath:helpers/Dummy.feature')
    * def username = result.username

  # After hooks #afterFeautre(keyword calls this fun after feature) #afterScenario calls fun after every scenario
    * configure afterScenario = function(){karate.call('classpath:helpers/Dummy.feature')}
    * configure afterFeature =
    """
        function(){
            karate.log('After feature text');
        }
    """

  Scenario: First scenario
    * print username
    * print 'This is first scenario'


  Scenario: Second scenario
    * print username
    * print 'This is the second scenario'
