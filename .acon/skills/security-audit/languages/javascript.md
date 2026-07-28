# Deep JavaScript & Node.js Language Security Guide

## 1. Prototype Pollution
In JavaScript, objects inherit properties from `Object.prototype`. If user input can set `__proto__`, `constructor.prototype`, or `prototype` keys during object copy/merge operations, it pollutes all objects across the V8 runtime.

### Vulnerable Merging
```javascript
// ❌ Dangerous: Recursive object merge without filtering prototype keys
function merge(target, source) {
    for (let key in source) {
        if (typeof source[key] === 'object') {
            if (!target[key]) target[key] = {};
            merge(target[key], source[key]);
        } else {
            target[key] = source[key];
        }
    }
    return target;
}

// Attack Payload:
// JSON.parse('{"__proto__": {"isAdmin": true}}')
// After merge, ({}).isAdmin is TRUE globally!
```

### Remediation
```javascript
// ✓ Secure: Freeze Object.prototype or validate keys
function safeMerge(target, source) {
    for (let key of Object.keys(source)) {
        if (key === '__proto__' || key === 'constructor' || key === 'prototype') {
            continue; // Ignore dangerous prototype keys
        }
        if (typeof source[key] === 'object' && source[key] !== null) {
            if (!target[key]) target[key] = {};
            safeMerge(target[key], source[key]);
        } else {
            target[key] = source[key];
        }
    }
    return target;
}
```

---

## 2. Unsafe Code Evaluation & Node.js VM Sandbox Escape
Node.js `vm` module is **NOT** a security sandbox. Code executing inside `vm.runInNewContext()` can escape to the host Node.js environment via constructor references.

```javascript
// ❌ Dangerous: VM Sandbox Escape
const vm = require('vm');
const code = `
  this.constructor.constructor('return process')().mainModule.require('child_process').execSync('id')
`;
vm.runInNewContext(code); // RCE on host server!

// ✓ Secure: Avoid running arbitrary user code in Node.js VM.
// Use isolated processes (Docker / WASM) for running untrusted code.
```

---

## 3. Node.js Event Loop Blocking & ReDoS
Regexes containing nested quantifiers (e.g. `(a+)+$`) cause exponential backtracking when evaluated against non-matching inputs, freezing the single-threaded Node.js Event Loop.

```javascript
// ❌ ReDoS: Catastrophic Backtracking Pattern
const regex = /^([a-zA-Z0-9]+)+$/;
regex.test("aaaaaaaaaaaaaaaaaaaaaaaaaaaaa!"); // Freezes Node.js main thread!

// ✓ Secure: Use linear-time regex engines (RE2) or avoid nested quantifiers.
```

---

## 4. NoSQL Operator Injection (MongoDB)
Express query parsers automatically parse `req.query` objects. Passing `req.query` directly to MongoDB filters allows attackers to inject query operators (`$gt`, `$ne`, `$regex`).

```javascript
// ❌ Dangerous: Passing parsed query object directly
app.post('/api/login', async (req, res) => {
    // If req.body is {"username": "admin", "password": {"$ne": null}}
    const user = await User.findOne({ username: req.body.username, password: req.body.password });
    // Bypasses password check!
});

// ✓ Secure: Cast inputs explicitly to Strings
app.post('/api/login', async (req, res) => {
    const username = String(req.body.username);
    const password = String(req.body.password);
    const user = await User.findOne({ username, password });
});
```
