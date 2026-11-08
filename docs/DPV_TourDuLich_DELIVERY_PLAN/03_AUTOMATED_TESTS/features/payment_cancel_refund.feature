Feature: Payment, cancellation and refund
  Scenario: Mock payment succeeds and states remain separate
    Given a booking is awaiting payment
    When the mock payment reports success
    Then payment state follows CHO_THANH_TOAN to DANG_XU_LY to THANH_CONG as applicable
    And booking state is updated only according to the business contract
    And booking status is not treated as payment status

  Scenario: Payment callback or request is processed idempotently
    Given the same payment event is received more than once
    When the event is processed repeatedly
    Then the payment is not recorded as successful more than once
    And duplicate side effects are prevented

  Scenario: Customer requests cancellation for own eligible booking
    Given the customer owns a booking eligible for cancellation
    When the customer submits a cancellation request
    Then the cancellation policy is applied by the backend
    And cancellation/refund records follow the defined state flow

  Scenario: Cancellation is rejected when business preconditions fail
    Given the booking is not eligible for the requested cancellation action
    When the customer requests cancellation
    Then the API rejects the action and preserves consistent data
