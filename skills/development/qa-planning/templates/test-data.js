// Live database for dashboard.html — the single source of truth for test cases and status.
// Same schema as TEST-CASE.json, wrapped in one assignment so the dashboard opens by double-click.
// Edit a case's `status` here (not_run | pass | fail | blocked | skipped) and refresh the dashboard.
window.TEST_DATA = {
  "feature": "Authentication",
  "planRef": "authentication-test-plan.md",
  "generatedFor": "{spec path or ticket link}",
  "statusLegend": ["not_run", "pass", "fail", "blocked", "skipped"],
  "flows": [
    {
      "id": "FLOW-SIGNIN",
      "name": "Sign in with OTP",
      "featureFile": "features/signin.feature",
      "requirementRef": "REQ-AUTH-001",
      "testCases": [
        {
          "id": "TC-001",
          "title": "Successful sign in through OTP verification",
          "priority": "P0",
          "type": "functional",
          "status": "not_run",
          "tags": ["smoke", "regression"],
          "requirementRef": "REQ-AUTH-001",
          "preconditions": [
            "Application is running",
            "Registered user jane@example.com exists"
          ],
          "testData": { "email": "jane@example.com", "otp": "123456" },
          "steps": [
            {
              "step": 1,
              "action": "Navigate to the sign-in page, enter the email and submit",
              "expectedResult": "An OTP is sent to the email and the OTP entry screen is shown"
            },
            {
              "step": 2,
              "action": "Enter the valid OTP and submit",
              "expectedResult": "User is redirected to the dashboard and a session cookie is set"
            }
          ],
          "postconditions": ["User has an active authenticated session"]
        },
        {
          "id": "TC-002",
          "title": "Wrong OTP is rejected",
          "priority": "P1",
          "type": "negative",
          "status": "not_run",
          "tags": ["regression"],
          "requirementRef": "REQ-AUTH-001",
          "preconditions": ["User has requested an OTP for jane@example.com"],
          "testData": { "email": "jane@example.com", "otp": "000000" },
          "steps": [
            {
              "step": 1,
              "action": "On the OTP entry screen, enter the wrong OTP and submit",
              "expectedResult": "Error 'Invalid or expired code' is shown and the user stays on the OTP entry screen"
            }
          ],
          "postconditions": ["No session is created"]
        }
      ]
    }
  ]
};
