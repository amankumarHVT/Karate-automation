@bankingSite
Feature: Instnt UI Automation

  Scenario: E2E Workflow creation

    Given driver https://dev.instnt.org/#/login
    * maximize()

    * click('body')
    * delay(2000)

    * input('#username', 'Kevin')
    * input('#password', 'Harris')
    * delay(2000)


    * click("//*[@type='submit']")

    And delay(3000)