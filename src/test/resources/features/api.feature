Feature: Sample API Test

  Scenario: Verify a POST request
    Given url 'https://dev2-api.instnt.org/auth/login'
    And  header Content-Type = 'application/json'
    And  header Accept = 'application/json'
    And  header X-CSRFTOKEN = 'PW5f1VGR5KTmk944yG76rn4r4SNFJI1GqHc1iNsGWBAtakXVlTVpQiwpLNalMnYb'
    And  header Authorization = 'Bearer YpW9pCZ7Y3daCz98wPFCDPACsXU4BXygza3VGuLWPUUhsK2Zj2tV2K2A9ShKECvL'
    And  request { username: 'shivam@instnt.org', password: 'Stage@12345' }
    When method post
    Then status 200
    And  match response.status == '1'



  Scenario: Verify a POST request for transaction
    Given url 'https://sandbox-api.instnt.org/public/transactions/'
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And request { hide_form_fields: 'false', redirect: 'false' , form_key: 'v1727349041679092', format:'json' }
    When method post
    Then status 201
    And match response.user_id == 195


  Scenario: Verify a PUT request for Submit Form
    Given url 'https://dev2-api.instnt.org/public/transactions/1'
    And request {zip: '10032'}
    When method PUT
    Then status 500
    And match response.message == 'Something went wrong. Please try again later.'
