# Real-World Vulnerability Case Studies & Exploit Analysis

This document outlines real-world vulnerability case studies across PHP, JavaScript/Node.js, Python, and C# applications. Understanding how these vulnerabilities manifest in the wild is critical for performing effective security audits.

## 1. PHP: Unsafe Deserialization in WordPress Plugins

**Vulnerability:** Object Injection / Unsafe Deserialization
**Target:** PHP (WordPress Plugin)

**Description:**
Many older PHP applications and WordPress plugins use `unserialize()` to process user-supplied data without adequate validation. If an attacker can control the serialized string passed to `unserialize()`, they can instantiate arbitrary PHP objects. If a suitable "gadget chain" (e.g., classes with magic methods like `__destruct()`, `__wakeup()`) exists within the application's loaded classes, this can lead to Remote Code Execution (RCE).

**Exploit Analysis:**
An attacker sends a crafted serialized payload in a cookie or POST parameter:
```php
// Payload
O:14:"EvilDestructor":1:{s:4:"data";s:17:"system('whoami');";}
```
When `unserialize()` processes this, it creates an instance of `EvilDestructor`. When the script ends, `__destruct()` is called, executing `system('whoami')`.

**Remediation:**
Avoid `unserialize()` on untrusted data. Use `json_encode()` and `json_decode()` for data serialization. If object serialization is absolutely necessary, use strong cryptographic signatures (e.g., HMAC) to verify the data's integrity before deserialization.

## 2. JavaScript (Node.js): Prototype Pollution in Utility Libraries

**Vulnerability:** Prototype Pollution
**Target:** JavaScript / Node.js (e.g., lodash, express)

**Description:**
Prototype pollution occurs when a JavaScript application improperly merges user-controlled data into an object. An attacker can inject properties into `Object.prototype`, which are then inherited by all JavaScript objects in the application. This can lead to Denial of Service (DoS), bypass of security checks, or even Remote Code Execution (RCE) if the polluted properties are used unsafely.

**Exploit Analysis:**
Consider a vulnerable merge function:
```javascript
function merge(target, source) {
  for (let key in source) {
    if (typeof target[key] === 'object' && typeof source[key] === 'object') {
      merge(target[key], source[key]);
    } else {
      target[key] = source[key];
    }
  }
}
```
An attacker provides a JSON payload: `{"__proto__": {"admin": true}}`.
The `merge` function pollutes `Object.prototype.admin = true`. Any subsequent object lacking the `admin` property will inherit this truthy value.

**Remediation:**
Validate JSON schemas rigorously. Avoid recursive merges on untrusted input, use safe merge libraries, or freeze the prototype using `Object.freeze(Object.prototype)`. Use `Object.create(null)` for dictionaries.

## 3. Python: Server-Side Template Injection (SSTI) in Jinja2

**Vulnerability:** Server-Side Template Injection (SSTI)
**Target:** Python (Flask/Jinja2)

**Description:**
SSTI occurs when user input is unsafely embedded into a template before rendering. In Python frameworks like Flask using Jinja2, an attacker can inject Jinja2 expressions to traverse the MRO (Method Resolution Order) and execute arbitrary code.

**Exploit Analysis:**
Vulnerable code:
```python
from flask import render_template_string
@app.route('/greet')
def greet():
    name = request.args.get('name')
    template = f"Hello {name}!"
    return render_template_string(template)
```
Payload: `{{config.__class__.__init__.__globals__['os'].popen('id').read()}}`
This payload traverses Python's object hierarchy to access the `os` module and execute the `id` command.

**Remediation:**
Never concatenate user input directly into template strings. Always pass user input as context variables to the template engine, allowing the engine to handle escaping and sandboxing properly.

## 4. C# (.NET): XML External Entity (XXE) Injection

**Vulnerability:** XML External Entity (XXE)
**Target:** C# / .NET

**Description:**
XXE occurs when an XML parser processes external entities from untrusted sources without restriction. In .NET, older versions of `XmlTextReader` or `XmlDocument` were vulnerable by default, allowing attackers to read local files, probe internal networks (SSRF), or cause DoS.

**Exploit Analysis:**
An attacker uploads an XML file containing a malicious external entity:
```xml
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE root [
  <!ENTITY xxe SYSTEM "file:///c:/windows/win.ini">
]>
<root>&xxe;</root>
```
If the parser resolves the entity, it returns the contents of `win.ini` in the application response.

**Remediation:**
Disable external entity resolution in XML parsers. In .NET, use `XmlReaderSettings` with `DtdProcessing = DtdProcessing.Prohibit` or `DtdProcessing.Ignore`. Ensure modern frameworks are updated, as they usually default to safe XML parsing settings.
