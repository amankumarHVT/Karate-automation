Feature: Create Transaction and return transactionId

  Scenario: Create a new transaction and return transactionId
    Given url 'https://dev2-api.instnt.org/public/transactions'
    And request
    """
    {
      "hide_form_fields": false,
      "redirect": false,
      "form_key": "v1741687642435056",
      "format": "json"
    }
    """
    When method POST
    Then status 201
    * print 'Create Transaction Response:', response

    # Extract transactionId
    * def transactionId = response.instnttxnid
    * print 'New Transaction ID is:', transactionId
    * if (!transactionId) karate.fail('transactionId is null or not found')
