Feature: Booking and passenger management
  Scenario: Customer creates booking when seats are available
    Given a public tour departure has enough available seats
    When the customer submits a valid booking with passengers
    Then the booking and passenger rows are committed atomically
    And the available capacity is updated consistently

  Scenario: Booking fails when departure is full
    Given a departure has no remaining seats
    When the customer attempts to book it
    Then the API returns the contract-defined conflict/business error
    And no partial booking is persisted

  Scenario: Concurrent bookings cannot exceed capacity
    Given only one seat remains on a departure
    When two booking requests attempt to reserve the final seat concurrently
    Then at most one booking succeeds
    And total reserved capacity does not exceed the departure capacity

  Scenario: Customer can only update own booking passengers
    Given a passenger belongs to another customer's booking
    When the current customer attempts to update that passenger
    Then the API denies the operation
