# Express, Koa, and Next.js Security Audit Guide

When auditing Node.js web frameworks, look for the following vulnerability patterns.

## 1. Middleware Ordering and Security (Express/Koa)
The order of middleware is crucial for security.

*   **Vulnerable Pattern:** Authentication/Authorization middleware placed *after* route handlers or sensitive operations.
    ```javascript
    // BAD: Route is accessible before auth check
    app.get('/admin/data', (req, res) => { res.send(secretData); });
    app.use(authMiddleware); 
    ```
*   **Missing Protections:** Check for missing security headers (e.g., using `helmet`) or rate limiting on sensitive routes (e.g., login).

## 2. Server-Side Rendering (SSR) Vulnerabilities (Next.js)
SSR can introduce vulnerabilities if user input is reflected insecurely in the initial HTML payload.

*   **Sinks to Check:** `dangerouslySetInnerHTML`, reflecting input directly in `getServerSideProps` without sanitization.
*   **Vulnerable Pattern:**
    ```jsx
    // BAD
    <div dangerouslySetInnerHTML={{ __html: router.query.userInput }} />
    ```
*   **Secure Pattern:** Avoid `dangerouslySetInnerHTML` unless absolutely necessary, and always sanitize the input using libraries like `DOMPurify` before rendering.

## 3. Insecure JWT Verification
JSON Web Tokens (JWT) must be verified correctly to prevent spoofing.

*   **Vulnerable Pattern:** Using `jwt.decode()` instead of `jwt.verify()`. `decode()` only parses the token but does not validate the signature.
    ```javascript
    // BAD: Signature not checked!
    const tokenData = jwt.decode(req.headers.authorization);
    ```
*   **Vulnerable Pattern:** Not specifying the allowed algorithms during verification, which can lead to algorithm confusion attacks (e.g., 'none' algorithm).
    ```javascript
    // GOOD
    jwt.verify(token, secret, { algorithms: ['HS256'] });
    ```

## 4. Prototype Pollution
JavaScript's prototype chain can be manipulated if object merging or cloning functions are implemented insecurely.

*   **Sinks to Check:** Recursive merge functions (e.g., `lodash.merge` in older versions), deep cloning, or object assignment from user input.
*   **Vulnerable Pattern:**
    ```javascript
    // BAD (Simplified example)
    function merge(target, source) {
        for (let key in source) {
            if (typeof target[key] === 'object' && typeof source[key] === 'object') {
                merge(target[key], source[key]);
            } else {
                target[key] = source[key];
            }
        }
    }
    // Exploit: {"__proto__": {"admin": true}}
    ```
*   **Secure Pattern:** Use secure, updated libraries for object manipulation, or freeze prototypes using `Object.freeze(Object.prototype)`.
