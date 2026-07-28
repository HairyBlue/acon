# Django & FastAPI Security Audit Guide

Guidelines for auditing Python web frameworks (Django and FastAPI).

## 1. Django ORM SQL Injection
Django's ORM is generally safe, but raw queries introduce SQLi risks.

*   **Sinks to Check:** `Model.objects.raw()`, `Model.objects.extra()`, `cursor.execute()`.
*   **Vulnerable Pattern:** String formatting in raw queries.
    ```python
    # BAD
    User.objects.raw(f"SELECT * FROM myapp_user WHERE username = '{username}'")
    ```
*   **Secure Pattern:** Use parameterized queries.
    ```python
    # GOOD
    User.objects.raw("SELECT * FROM myapp_user WHERE username = %s", [username])
    ```

## 2. Server-Side Template Injection (SSTI) in Jinja2/Django Templates
Rendering templates from strings using user input can lead to RCE.

*   **Sinks to Check:** `render_template_string()` (Jinja2), `Template(user_input).render()` (Django).
*   **Vulnerable Pattern:**
    ```python
    # BAD
    from flask import render_template_string
    @app.route('/hello')
    def hello():
        name = request.args.get('name')
        return render_template_string('Hello ' + name + '!')
    ```
*   **Secure Pattern:** Always pass user data as context variables to templates, rather than concatenating into the template string itself.

## 3. Pydantic Mass Update (FastAPI)
Similar to Mass Assignment, blindly updating Pydantic models with user data can allow unauthorized attribute modification.

*   **Vulnerable Pattern:** Accepting a comprehensive Pydantic model on an update endpoint and applying all fields to the database object without filtering.
*   **Secure Pattern:** Use `exclude_unset=True` when updating, or create specific request models (DTOs) that only contain the fields allowed to be updated.
    ```python
    # GOOD
    update_data = user_in.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_user, field, value)
    ```

## 4. OAuth2 & JWT Verification
Ensure authentication schemes are implemented correctly.

*   **Check:** Does the FastAPI dependency (`Depends()`) properly validate the token signature and expiration?
*   **Check:** Are scopes properly verified for authorization on restricted endpoints?
*   **Vulnerable Pattern:** Trusting token contents without verifying the signature (e.g., using a mock verification function in production).
