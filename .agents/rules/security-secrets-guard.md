# Security & Secrets Guard

Zero-leakage policy for credentials, environment files, and sensitive keys.

## Strict Rules
1. **Never Display or Log Secrets:** Never echo, cat, or print raw `.env`, `.env.local`, API tokens, JWT secrets, private SSH/TLS keys (`*.pem`, `id_rsa`), or database credentials into chat, artifacts, or progress logs.
2. **Never Stage or Commit Credentials:** Ensure all secret files, `.env` variants, credentials, and local tokens are strictly covered by `.gitignore`. Never add or stage secrets in git.
3. **Environment-First Configuration:** All secrets must be loaded via runtime environment variables, never hardcoded in code or configuration files.
4. **Human-in-the-Loop Credential Gate:** If a required secret or API token is missing during execution, do not attempt to guess or bypass. Escalate to the Captain via standard Section 6 escalation.
