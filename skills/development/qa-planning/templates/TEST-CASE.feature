# Gherkin test cases for {Feature name}
# One .feature file per feature area. One behavior per scenario.
# Tags carry metadata: @P0/@P1/@P2 priority, @regression, @smoke, and @REQ-xxx traceability.

@authentication @REQ-AUTH-001
Feature: {Feature name}
  As a {role}
  I want to {capability}
  So that {benefit}

  # Preconditions shared by every scenario in this feature.
  Background:
    Given the application is running
    And a registered user "jane@example.com" exists with password "Str0ng!Pass"

  @P0 @smoke @regression @TC-001
  Scenario: {Happy path — successful login}
    Given the user is on the login page
    When the user enters "jane@example.com" and "Str0ng!Pass"
    And the user submits the login form
    Then the user is redirected to the dashboard
    And a session cookie is set

  @P1 @negative @TC-002
  Scenario: {Wrong password is rejected}
    Given the user is on the login page
    When the user enters "jane@example.com" and "wrong-password"
    And the user submits the login form
    Then an error "Invalid email or password" is shown
    And the user remains on the login page

  # Use Scenario Outline for boundary values and variations — drive one row per edge case.
  @P1 @boundary @TC-003
  Scenario Outline: {Input validation on the login form}
    Given the user is on the login page
    When the user enters "<email>" and "<password>"
    And the user submits the login form
    Then the result is "<outcome>"
    And the message "<message>" is shown

    Examples:
      | email             | password    | outcome  | message                       |
      | ""                | "Str0ng!"   | rejected | Email is required             |
      | "jane@example.com"| ""          | rejected | Password is required          |
      | "not-an-email"    | "Str0ng!"   | rejected | Enter a valid email address   |
      | "jane@example.com"| "Str0ng!Pass"| success  |                               |
