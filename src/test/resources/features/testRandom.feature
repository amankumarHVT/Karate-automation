Feature: Submit Form API Validation Tests

  Background:
    * def createResult = call read('create&saveTxnID.feature')
    * def transactionId = createResult.transactionId
    * print 'Got Transaction ID from create feature:', transactionId
    * def baseUrl = 'https://dev2-api.instnt.org/public/transactions/' + transactionId
    * def baseFormData =
    """
    {
      "formId": "#(java.util.UUID.randomUUID() + '')",
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

  @negative_nationalId
  Scenario Outline: Validate nationalId field negative cases

    * def payload = karate.jsonPath(baseFormData,'$')

    * if ('<nationalIdValue>' == 'notPresent') karate.remove('payload', 'nationalId')

#    * if ('<nationalIdValue>' == 'null') payload.nationalId = null
#    * if ('<nationalIdValue>' == 'emptyString') payload.nationalId = ''
#    * if ('<nationalIdValue>' == 'invalidFormat1') payload.nationalId = '59966-7782'
#    * if ('<nationalIdValue>' == 'invalidFormat2') payload.nationalId = '599667782'
#    * if ('<nationalIdValue>' == 'invalidFormat3') payload.nationalId = '599-666-7782'
#    * if ('<nationalIdValue>' == 'nonNumeric') payload.nationalId = '599-66-778A'
#    * if ('<nationalIdValue>' == 'allZeros') payload.nationalId = '000-00-0000'
#    * if ('<nationalIdValue>' == 'invalidChars') payload.nationalId = '5@9-66-7742'

    * print 'Test case: <nationalIdValue>'
    * print 'Payload sent:', payload

    Given url baseUrl
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And request payload
    When method PUT

    * print 'Response status:', responseStatus
    * print 'Response body:', response

    Then status 400
    And match response.message contains '<expectedError>'

    Examples:
      | nationalIdValue | expectedError |
      | notPresent      | nationalId field is required. |
#      | null            | nationalId field is required. |
#      | emptyString     | nationalId This field may not be blank. |
#      | invalidFormat1  | nationalId \'59966-7782\' is invalid.   |
#      | invalidFormat2  | nationalId \'599667782\' is invalid.    |
#      | invalidFormat3  | nationalId \'599-666-7782\' is invalid. |
#      | nonNumeric      | nationalId \'599-66-778A\' is invalid.  |
#      | invalidChars    | nationalId \'5@9-66-7742\' is invalid.  |


  @negative_clientIp
  Scenario Outline: Validate client_ip field negative cases

    * def payload = karate.jsonPath(baseFormData, '$')

    * if ('<clientIpValue>' == 'null') payload.client_ip = null
    * if ('<clientIpValue>' == 'emptyString') payload.client_ip = ''
    * if ('<clientIpValue>' == 'invalidFormat1') payload.client_ip = '256.256.256.256'
    * if ('<clientIpValue>' == 'invalidFormat2') payload.client_ip = '192.168.1'
    * if ('<clientIpValue>' == 'invalidFormat3') payload.client_ip = '192.168.1.1.1'
    * if ('<clientIpValue>' == 'nonNumeric') payload.client_ip = '192.168.1.abc'
    * if ('<clientIpValue>' == 'outOfRange') payload.client_ip = '999.999.999.999'
    * if ('<clientIpValue>' == 'invalidChars') payload.client_ip = '192.168@1#1'
    * if ('<clientIpValue>' == 'leadingZeros') payload.client_ip = '192.168.001.001'
    * if ('<clientIpValue>' == 'textFormat') payload.client_ip = 'invalid.ip.address'

    * print 'Test case: <clientIpValue>'
    * print 'Payload sent:', payload

    Given url baseUrl
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And request payload
    When method PUT

    * print 'Response status:', responseStatus
    * print 'Response body:', response

    Then status 400
    And match response.message contains '<expectedError>'

    Examples:
      | clientIpValue   | expectedError                                      |
      | null            | client_ip field is required.                       |
      | emptyString     | client_ip This field may not be blank.            |
      | invalidFormat1  | client_ip \'256.256.256.256\' is invalid.         |
      | invalidFormat2  | client_ip \'192.168.1\' is invalid.               |
      | invalidFormat3  | client_ip \'192.168.1.1.1\' is invalid.           |
      | nonNumeric      | client_ip \'192.168.1.abc\' is invalid.           |
      | outOfRange      | client_ip \'999.999.999.999\' is invalid.         |
      | invalidChars    | client_ip \'192.168@1#1\' is invalid.             |
      | leadingZeros    | client_ip \'192.168.001.001\' is invalid.         |
      | textFormat      | client_ip \'invalid.ip.address\' is invalid.      |