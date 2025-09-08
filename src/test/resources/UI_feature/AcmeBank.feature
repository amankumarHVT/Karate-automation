@acmebank
Feature: AcmeBank UI Automation

  Background:
    * def createResult = call read('create&saveWorkflowID.feature')
    * def WorkflowID = createResult.WorkflowID

  Scenario: E2E transaction For AcmeBank
    Given driver 'https://dev.acmebank.org/'

    * maximize()
    And delay(500)

    And click('.setting')
    And delay(4000)

#    * waitForEnabled('#filled-required').mouse().click()
#    * clear('#filled-required')
    * input('//*[@id = "filled-required"]', WorkflowID)


    And delay(500)
    * input('#filled-required', WorkflowID)
    And delay(3000)


    * click("//*[@type='button']")
    And delay(2000)

   * click('.getStarted')
    And delay(3000)

    * input('#firstName', 'Kevin')
    * input('#surName', 'Harris')
    And delay(1000)
    And click("//*[@type='button']/*[text()='Next']")
    And delay(2000)

    When input('#email', 'Kharris@yahoo.com')
    And input('#mobileNumber-label', '374-263-6617')
    And delay(1000)
    And click("//*[@type='button'][2]")
    And delay(3000)

    * mouse("//*[@id='mui-component-select-country']").click()
    * mouse(100, 200).go()
    * waitForEnabled("//*[@id='United States']").mouse().click()
    * delay(2000)

    * input("//*[@id='physicalAddress']", '5327 Lee Fall')
    * input("//*[@id='city']", 'East Pamelamouth')
    * input("//*[@id='state-label']", 'ME')
    * input("//*[@id='zip-label']", '43665')

    * click("//*[@type='button'][2]")
    * delay(30000)









