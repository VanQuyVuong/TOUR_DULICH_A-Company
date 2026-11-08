Feature: Guide assignments, progress and incidents
  Scenario: Guide sees only assigned departures
    Given the guide has assignments for a subset of departures
    When the guide requests assigned tours
    Then only authorized assignments are returned

  Scenario: Assignment prevents overlapping guide schedules
    Given a guide already has an overlapping assignment
    When a manager assigns the guide to another overlapping departure
    Then the assignment is rejected

  Scenario: Guide updates progress for an assigned tour
    Given the guide is assigned to an active departure
    When the guide submits a valid progress update
    Then the progress and evidence follow the contract

  Scenario: Guide cannot update progress for an unassigned departure
    Given the guide is not assigned to a departure
    When the guide submits progress for that departure
    Then the API denies the operation

  Scenario: Guide reports an incident
    Given the guide is assigned to the affected departure
    When the guide submits an incident report
    Then the incident is persisted and made available to authorized operations staff
