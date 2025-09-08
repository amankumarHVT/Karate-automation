Feature: Sample API Test

  Scenario: Create transaction & submit form dynamically

    # 1️⃣ Create a new transaction dynamically
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


    # 2️⃣ Capture transactionId from the response
    #    -- Adjust this path if your API nests transaction_id in another object (print response to confirm)
    * def transactionId = response.instnttxnid
    * print 'New Transaction ID is:', transactionId
    * if (!transactionId) karate.fail('transactionId is null or not found in create transaction response')

    # 3️⃣ Prepare formData with dynamic formId (UUID)
#   * def uuid = function(){ return java.util.UUID.randomUUID() + '' }
   * def formData =
    """
    {
      "formId": "#(uuid())",
      "zip": "10032",
      "city": "NEW YORK",
      "email": "fredis05@icloud.com",
      "state": "NY",
      "country": "US",
      "surName": "Severino",
      "income": "4821",
      "nationalId": "599-66-7782",
      "client_ip": "186.43.244.135",
      "submission_date": "2023-09-15",
      "firstName": "Fredis",
      "mobileNumber": "+16465415103",
      "physicalAddress": "403 W 154TH ST APT 2B",
      "fingerprint": "{\"requestId\":\"1741616048971.1ESL7f\",\"confidence\":{\"revision\":\"v1.1\",\"score\":0.88},\"meta\":{\"version\":\"v1.1.3154+a8b3e698b\"},\"visitorFound\":true,\"visitorId\":\"k0SCT0ju04Dg5YxMUT8p\"}",
      "dob": "1968-11-05"
    }
    """

    # 4️⃣ Use the captured transactionId in the next API call
    Given url 'https://dev2-api.instnt.org/public/transactions/' + transactionId
    And request formData
    When method PUT
    Then status 200
    * print 'Generated UUID is:', formData.formId
