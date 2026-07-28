# Supply Chain & Infrastructure Security

This document covers vulnerabilities related to the software supply chain and underlying infrastructure.

## 1. Supply Chain Vulnerabilities
*   **Dependency Confusion**: Tricking package managers into downloading malicious packages from public registries instead of internal ones.
*   **Vulnerable Dependencies (CVEs)**: Using outdated third-party libraries with known vulnerabilities.
*   **Typosquatting**: Registering domains or packages with names similar to popular ones to distribute malware.

## 2. Docker & Container Security
*   **Root Privileges**: Running containers as the root user.
*   **Exposed Docker Socket**: Exposing the Docker daemon socket (`/var/run/docker.sock`), allowing container escape.
*   **Insecure Registries**: Pulling images from untrusted or unauthenticated registries.
*   **Hardcoded Secrets**: Storing secrets or credentials within container images.

## 3. Serverless Architecture
*   **Over-privileged IAM Roles**: Granting functions broader permissions than necessary.
*   **Insecure Temporary Storage**: Storing sensitive data in `/tmp` without encryption or cleanup.
*   **Event Injection**: Injecting malicious payloads into event triggers (e.g., S3 upload, SQS message).

## 4. LLM Security Audit Risks
*   **Prompt Injection**: Manipulating LLM inputs to bypass safety filters or execute unintended actions.
*   **Data Leakage**: Exposing sensitive training data or user interactions through the LLM.
*   **Insecure Output Handling**: Failing to sanitize LLM outputs before rendering them, leading to XSS or command injection.
