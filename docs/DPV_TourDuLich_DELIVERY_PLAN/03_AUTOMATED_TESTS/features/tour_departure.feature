Feature: Tour and departure lifecycle
  Scenario: Manager submits a valid tour for approval
    Given a manager owns a valid draft tour
    When the manager submits the tour
    Then the tour state changes from NHAP to CHO_DUYET

  Scenario: Customer cannot book a non-public tour
    Given a tour is not public
    When a customer requests to book a departure of that tour
    Then the booking is rejected by the backend

  Scenario: Departure availability reflects remaining capacity
    Given a departure has capacity and existing confirmed seats
    When availability is requested
    Then remaining seats are calculated by the backend

  Scenario: Invalid departure transition is rejected
    Given a departure is in a state where the requested action is not allowed
    When the caller attempts the transition
    Then the API rejects it without changing the stored state
