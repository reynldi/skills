# One flow per file. Keep only scenarios that prove a requirement or material risk.

@{feature} @REQ-001
Feature: {Flow name}

  Background:
    Given {required state}

  @P0 @TC-001
  Scenario: {successful outcome}
    When {user action}
    Then {observable result}

  @P1 @TC-002
  Scenario: {important failure or boundary}
    When {invalid action or condition}
    Then {safe observable result}
