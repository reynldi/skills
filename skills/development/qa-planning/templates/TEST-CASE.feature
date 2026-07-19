# Gherkin test cases for a SINGLE FLOW.
# Generate ONE .feature file per discovered flow (signin, onboarding, invitations, ...).
# This example is the sign-in flow: sign in -> verify OTP -> done. Do not mix other flows in here.
# Tags carry metadata: @P0/@P1/@P2 priority, @regression, @smoke, and @REQ-xxx / @TC-xxx traceability.

@authentication @signin @REQ-AUTH-001
Feature: Sign in with OTP
  As a registered user
  I want to sign in with my email and a one-time passcode
  So that I can access my account securely

  # Preconditions shared by every scenario in this flow.
  Background:
    Given the application is running
    And a registered user "jane@example.com" exists

  @P0 @smoke @regression @TC-001
  Scenario: Successful sign in through OTP verification
    Given the user is on the sign-in page
    When the user enters "jane@example.com" and submits
    Then an OTP is sent to "jane@example.com"
    And the OTP entry screen is shown
    When the user enters the valid OTP "123456"
    Then the user is redirected to the dashboard
    And a session cookie is set

  @P1 @negative @TC-002
  Scenario: Wrong OTP is rejected
    Given the user has requested an OTP for "jane@example.com"
    And the user is on the OTP entry screen
    When the user enters the wrong OTP "000000"
    Then an error "Invalid or expired code" is shown
    And the user remains on the OTP entry screen

  @P1 @boundary @TC-003
  Scenario: Expired OTP is rejected
    Given the user requested an OTP for "jane@example.com" more than 10 minutes ago
    And the user is on the OTP entry screen
    When the user enters that OTP
    Then an error "Invalid or expired code" is shown
    And a "Resend code" option is available

  # Use Scenario Outline for input variations on a single step of this flow.
  @P1 @boundary @TC-004
  Scenario Outline: Email validation on the sign-in page
    Given the user is on the sign-in page
    When the user enters "<email>" and submits
    Then the result is "<outcome>"
    And the message "<message>" is shown

    Examples:
      | email              | outcome  | message                     |
      | ""                 | rejected | Email is required           |
      | "not-an-email"     | rejected | Enter a valid email address |
      | "jane@example.com" | accepted |                             |
