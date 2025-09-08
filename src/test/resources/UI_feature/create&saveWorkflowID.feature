Feature: API extraction for AcmeBank UI Automation

  Scenario: Create a new transaction and return workFlowID
    Given url 'https://dev2-api.instnt.org/public/transactions/'
    And request
    """
    {
    "hide_form_fields": false,
    "redirect": false,
    "form_key": "v1750078462478014",
    "format":"json"
     }
     """
    When method POST
    Then status 201
    * print 'Create Transaction Response:', response

    # Capturing workflow ID
    * def WorkflowID = response.form_key_id
    * print 'New WorkFlow ID is:', WorkflowID
    * if (!WorkflowID) karate.fail('transactionId is null or not found')