@full_neg
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


  @negative_Zip
  Scenario Outline: Validate zip field negative cases

    * def payload = karate.jsonPath(baseFormData, '$')

    * if ('<zipValue>' == 'notPresent') karate.remove('payload', 'zip')
    * if ('<zipValue>' == 'null') payload.zip = null
    * if ('<zipValue>' == 'emptyString') payload.zip = ''
    * if ('<zipValue>' == 'nullString') payload.zip = 'NULL'
    * if ('<zipValue>' == 'nonNumericString') payload.zip = 'abcde'
    * if ('<zipValue>' == 'tooLong') payload.zip = '123456'

    * print 'Test case: <zipValue>'
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
      | zipValue         | expectedError                    |
      | notPresent       | zip field is required.           |
      | null             | zip field is required.           |
      | emptyString      | zip This field may not be blank. |
      | nullString       | Zip \'NULL\' is invalid.         |
      | tooLong          | Zip \'123456\' is invalid.       |
      | nonNumericString | Zip \'ABCDE\' is invalid.        |

  @negative_City
  Scenario Outline: Validate city field negative cases

    * def payload = karate.jsonPath(baseFormData, '$')
    * if ('<cityValue>' == 'notPresent') karate.remove('payload', 'city')
    * if ('<cityValue>' == 'null') payload.city = null
    * if ('<cityValue>' == 'emptyString') payload.city = ''
    * if ('<cityValue>' == 'invalidString') payload.city = '12345'
    * if ('<cityValue>' == 'tooLong') payload.city = 'ThisCityNameIsDefinitelyWayTooLongMoreThan30Chars'

    * print 'Test case: <cityValue>'
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
      | cityValue     | expectedError                                                                                          |
      | notPresent    | city field is required.                                                                               |
      | null          | city field is required.                                                                               |
      | emptyString   | city This field may not be blank.                                                                     |
      | invalidString | City name \'12345\' is invalid.                                                                       |
      | tooLong       | City name \'ThisCityNameIsDefinitelyWayTooLongMoreThan30Chars\' is invalid.                           |

  @negative_email
  Scenario Outline: Validate email field negative cases

    * def payload = karate.jsonPath(baseFormData, '$')
    * if ('<emailValue>' == 'notPresent') karate.remove('payload', 'email')
    * if ('<emailValue>' == 'null') payload.email = null
    * if ('<emailValue>' == 'emptyString') payload.email = ''
    * if ('<emailValue>' == 'tooLong') payload.email = 'userwithaverylongemailaddressdesignedtotestthemaximumlengthallowedforanemailintheapimustexceedonehundredcharacters@example.com'

    * print 'Test case: <emailValue>'
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
      | emailValue  | expectedError                                        |
      | notPresent  | email field is required.                             |
      | null        | email field is required.                             |
      | emptyString | email This field may not be blank.                   |
      | tooLong     | Email length exceeds limit of 100 characters         |


  @negative_state
  Scenario Outline: Validate state field negative cases including length check

    * def payload = karate.jsonPath(baseFormData, '$')
    * if ('<stateValue>' == 'notPresent') karate.remove('payload', 'state')
    * if ('<stateValue>' == 'null') payload.state = null
    * if ('<stateValue>' == 'emptyString') payload.state = ''
    * if ('<stateValue>' != 'notPresent' && '<stateValue>' != 'null' && '<stateValue>' != 'emptyString') payload.state = '<stateValue>'

    * print 'Test case: <stateValue>'
    * print 'Payload sent:', payload

    Given url baseUrl
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And request payload
    When method PUT

    * print 'Response status:', responseStatus
    * print 'Response body:', response

    Then status 400
    And match response.message == '<expectedError>'

    Examples:
      | stateValue   | expectedError                                     |
      | notPresent   | state field is required.                          |
      | null         | state field is required.                          |
      | emptyString  | state This field may not be blank.                |
      | N            | State \'N\' is not in valid ISO 3166-2 format     |
      | NYA          | State \'NYA\' is not in valid ISO 3166-2 format   |
      | 12           | State \'12\' is not in valid ISO 3166-2 format    |


  @negative_country
  Scenario Outline: Validate country field only accepts US and CA

    * def payload = karate.jsonPath(baseFormData, '$')
    * if ('<countryValue>' == 'notPresent') karate.remove('payload', 'country')
    * if ('<countryValue>' == 'null') payload.country = null
    * if ('<countryValue>' == 'emptyString') payload.country = ''
    * if ('<countryValue>' != 'notPresent' && '<countryValue>' != 'null' && '<countryValue>' != 'emptyString') payload.country = '<countryValue>'

    * print 'Test case: <countryValue>'
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
      | countryValue | expectedError                     |
      | notPresent   | country field is required.        |
      | null         | country field is required.        |
      | emptyString  | country This field may not be blank. |
      | UK           | Invalid format for Country.       |
      | IN           | Invalid format for Country.       |
      | FR           | Invalid format for Country.       |
      | AU           | Invalid format for Country.       |


  @negative_firstname
  Scenario Outline: Validate firstName field negative cases

    * def payload = karate.jsonPath(baseFormData, '$')

    * if ('<firstNameValue>' == 'notPresent') karate.remove('payload', 'firstName')
    * if ('<firstNameValue>' == 'null') payload.firstName = null
    * if ('<firstNameValue>' == 'emptyString') payload.firstName = ''
    * if ('<firstNameValue>' == 'whitespaceOnly') payload.firstName = '   '
    * if ('<firstNameValue>' == 'tooLong') payload.firstName = 'a'.repeat(101)
    * if ('<firstNameValue>' == 'Invalid') payload.firstName = 'John123@#'

    * print 'Test case: <firstNameValue>'
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
      | firstNameValue | expectedError                             |
      | notPresent     | firstName field is required.              |
      | null           | firstName field is required.              |
      | emptyString    | firstName This field may not be blank.    |
      | whitespaceOnly | firstName This field may not be blank.    |
      | tooLong        | FirstName aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa is invalid.     |
      | Invalid        | FirstName John123@# is invalid.           |

  @negative_surname
  Scenario Outline: Validate surName field negative cases

    * def payload = karate.jsonPath(baseFormData, '$')

    * if ('<surNameValue>' == 'notPresent') karate.remove('payload', 'surName')
    * if ('<surNameValue>' == 'null') payload.surName = null
    * if ('<surNameValue>' == 'emptyString') payload.surName = ''
    * if ('<surNameValue>' == 'whitespaceOnly') payload.surName = '   '
    * if ('<surNameValue>' == 'tooLong') payload.surName = 'a'.repeat(101)
    * if ('<surNameValue>' == 'nonAlphabetic') payload.surName = 'Smith123@#$'

    * print 'Test case: <surNameValue>'
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
      | surNameValue   | expectedError                                |
      | notPresent     | surName field is required.                   |
      | null           | surName field is required.                   |
      | emptyString    | surName This field may not be blank.         |
      | whitespaceOnly | surName This field may not be blank.         |
      | tooLong        | SurName aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa is invalid. |
      | nonAlphabetic  | SurName Smith123@#$ is invalid.              |


