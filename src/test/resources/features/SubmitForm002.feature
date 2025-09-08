Feature: Submit Form using transaction from separate feature


  Scenario: Submit form to newly created transaction
    # 1️⃣ Call the create transaction feature and get the ID
    * def createResult = call read('classpath:com.example.karate/create&saveTxnID.feature')
    * def transactionId = createResult.transactionId
    * print 'Got Transaction ID from create feature:', transactionId

    # 2️⃣ Prepare form data
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

    # 3️⃣ Submit the form using the transactionId
    Given url 'https://dev2-api.instnt.org/public/transactions/' + transactionId
    And request formData
    When method PUT
    Then status 200
    * print 'Form submitted successfully for Transaction:', transactionId
    * print 'Generated UUID is:', formData.formId
