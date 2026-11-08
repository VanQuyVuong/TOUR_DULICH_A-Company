Feature: Authentication and session security
  Scenario: Customer registers successfully
    Given the email is not registered
    When the customer submits valid registration data
    Then the account and customer profile are created atomically
    And the customer role is assigned
    And the stored password is a BCrypt hash

  Scenario: Duplicate email registration is rejected
    Given an account already exists for the email
    When the customer registers with that email
    Then the API returns a validation conflict
    And no partial customer or role record is created

  Scenario: Locked account cannot log in
    Given the account is locked
    When the account submits valid credentials
    Then login is rejected

  Scenario: Refresh token is invalidated after logout
    Given the customer has an active refresh session
    When the customer logs out and then refreshes the old token
    Then refresh is rejected

  Scenario: Forgot password does not reveal account existence
    When reset is requested for an existing or unknown email
    Then the public response does not disclose whether the email exists
