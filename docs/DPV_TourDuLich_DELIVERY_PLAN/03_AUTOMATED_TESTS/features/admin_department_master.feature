Feature: Admin account, department and master data management
  Scenario: Admin changes a user's role and history is recorded
    Given an admin selects an existing account and a valid role
    When the role is changed
    Then the current role assignment is updated
    And role history is recorded

  Scenario: Locking an account invalidates its active session
    Given an account has an active refresh session
    When admin locks the account
    Then the session is invalidated and login/refresh is rejected

  Scenario: Referenced master data is deactivated instead of hard-deleted
    Given a master data row is referenced by business records
    When admin removes it from active use
    Then the record is deactivated according to the contract
    And existing references remain valid

  Scenario: Only one active department manager is allowed
    Given a department already has an active manager
    When a second active manager is assigned to the same department
    Then the operation is rejected or resolves according to the approved contract
