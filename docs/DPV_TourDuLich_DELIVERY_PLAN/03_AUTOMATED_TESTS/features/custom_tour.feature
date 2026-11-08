Feature: Custom tour request and quotation
  Scenario: Customer creates a custom tour request
    Given the customer submits valid dates, party size and destinations
    When the request is submitted
    Then the request and requested destinations are saved atomically

  Scenario: Manager assigns a request to departments
    Given a valid request is received by the overall manager
    When the manager assigns responsible departments
    Then the assignment is persisted and the request follows the defined workflow

  Scenario: Department manager processes only assigned department requests
    Given a request is assigned to the department manager's department
    When the department manager processes the request
    Then the action is authorized and the state transition is valid

  Scenario: Customer confirms a quotation belonging to their request
    Given a quotation belongs to the current customer's request and is confirmable
    When the customer confirms the quotation
    Then the system records confirmation and follows the custom-tour workflow

  Scenario: Customer cannot confirm another customer's quotation
    Given a quotation belongs to another customer
    When the current customer attempts to confirm it
    Then the API denies the operation
