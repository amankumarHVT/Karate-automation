@UI_test01
Feature: browser automation 1

  @qwe
  Scenario: Try login Instnt successfully

    Given driver 'https://dev.instnt.org/#/login'
    And input('#mat-input-0', 'qaautomation@instnt.org')
    And input('#mat-input-1', 'Stage@12345')
    When click("body > app-root > div > app-login > div > button > span.mat-ripple.mat-mdc-button-ripple")
    Then waitForUrl('https://dev.instnt.org/#/dashboard')