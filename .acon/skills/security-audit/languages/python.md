# Deep Python Language Security Guide

## 1. Unsafe Pickle Deserialization
Python's `pickle` module executes arbitrary bytecode specified by the `__reduce__()` magic method during deserialization.

```python
# ❌ Dangerous: Unserializing untrusted pickle data
import pickle

user_cookie = request.COOKIES.get('session')
data = pickle.loads(user_cookie) # Triggers arbitrary RCE!

# ✓ Secure: Use JSON for serialization
import json
data = json.loads(user_cookie)
```

---

## 2. PyYAML Unsafe Loader
Standard `yaml.load()` in PyYAML supports instantiating arbitrary Python objects (`!!python/object/apply`).

```python
# ❌ Dangerous: Unsafe PyYAML loading
import yaml
config = yaml.load(user_yaml_input) # RCE via YAML tags!

# ✓ Secure: Always specify SafeLoader or use safe_load()
config = yaml.safe_load(user_yaml_input)
```

---

## 3. Subprocess Command Injection (`shell=True`)
Passing string formatting to `subprocess.Popen` or `subprocess.run` with `shell=True` invokes `/bin/sh`, enabling shell command injection via `;`, `|`, or `&&`.

```python
# ❌ Dangerous: String formatting with shell=True
import subprocess
filename = request.GET.get('filename')
subprocess.run(f"ls -la {filename}", shell=True) # Command Injection!

# ✓ Secure: Pass argument list with shell=False
subprocess.run(["ls", "-la", filename], shell=False)
```

---

## 4. Server-Side Template Injection (Jinja2)
Passing user input directly into Jinja2 template constructors allows attackers to navigate Python class hierarchies via `__mro__` and `__subclasses__()` to access `os.system`.

```python
# ❌ Dangerous: Rendering user input as template string
from flask import render_template_string
template = f"Hello {user_input}"
return render_template_string(template) # SSTI vulnerability!

# ✓ Secure: Render template files with passed variables
return render_template("hello.html", name=user_input)
```
