# Logic Flaw Patterns

Real-world logic vulnerability patterns observed in numerous bug bounty reports.

## 1. Password Reset Bypass
*   **Token Predictability**: Weak random number generators used for reset tokens.
*   **Token Leakage**: Reset tokens leaked via Referer headers or third-party analytics.
*   **Host Header Poisoning**: Manipulating the Host header to send the password reset link to an attacker-controlled domain.
*   **Parameter Pollution**: Providing multiple email addresses in the request, sending the token to the attacker's email.

## 2. Captcha Reuse and Bypass
*   **Replay Attacks**: Reusing a valid captcha solution for multiple requests.
*   **Missing Validation**: The server fails to validate the captcha if the parameter is entirely removed from the request.
*   **OCR Vulnerability**: Simple captchas that can be easily solved by Optical Character Recognition (OCR) tools.

## 3. Payment Amount Tampering
*   **Client-Side Pricing**: Trusting the price or total amount submitted by the client instead of calculating it server-side.
*   **Negative Values**: Submitting negative quantities to reduce the overall order total.
*   **Currency Manipulation**: Changing the currency parameter without adjusting the numerical amount (e.g., paying 100 JPY instead of 100 USD).

## 4. Account Takeover via Logic Flaws
*   **OAuth Misconfigurations**: Improper validation of state parameters or relying on unverified email addresses from identity providers.
*   **Registration Overwrite**: Registering an account with an existing email address, potentially gaining access to the original user's data.
