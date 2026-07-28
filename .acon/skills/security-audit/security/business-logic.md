# Business Logic Flaws

This guide details common business logic vulnerabilities that often bypass automated scanners but can cause significant impact.

## 1. Financial Tampering
*   **Total Manipulation**: Modifying item prices or total cart values during checkout.
*   **Negative Values**: Injecting negative quantities or prices to reduce the total cost or cause integer underflows.
*   **Currency Conversion Flaws**: Exploiting rounding errors or outdated exchange rates in multi-currency systems.

## 2. Discounts and Promotions
*   **Coupon Code Abuse**: Applying single-use coupons multiple times or stacking incompatible discounts.
*   **Referral Exploitation**: Creating fake accounts to exploit referral bonuses.
*   **Refund Abuse**: Requesting refunds for items not purchased or manipulating refund amounts.

## 3. Quota and Rate Limit Bypass
*   **Race Conditions (Time-of-Check to Time-of-Use)**: Sending simultaneous requests to exceed usage limits (e.g., withdrawing more funds than available).
*   **Feature Gating Bypass**: Accessing premium features by manipulating client-side state or predictable API endpoints.

## 4. State Machine Flaws
*   **Skipping Steps**: Bypassing mandatory workflow steps (e.g., skipping payment and going straight to order confirmation).
*   **Invalid State Transitions**: Forcing an application into an unexpected state.
*   **Pre-condition Failures**: Executing actions when prerequisite conditions are not met.
