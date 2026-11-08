Feature: Role, ownership and department-scope authorization
  Scenario: Anonymous caller accesses a protected endpoint
    When an unauthenticated caller requests a protected resource
    Then the API returns 401

  Scenario: Customer cannot read another customer's booking
    Given customer A owns a booking and customer B is authenticated
    When customer B requests that booking
    Then the API returns 403 or the contract-defined non-disclosing 404
    And no booking data is disclosed

  Scenario: Non-admin cannot call admin account endpoint
    Given a user without the required admin permission is authenticated
    When the user requests the admin account list
    Then the API returns 403

  Scenario: Department manager cannot access another department request
    Given a request belongs to Department B and the caller manages Department A
    When the caller opens or processes the request
    Then the API denies access and no data is modified
