# Python & Django / FastAPI / Flask Security Checklist

## D1: Injection
- **SQL Injection**:
  - Concatenating user input into raw SQL queries: `cursor.execute("SELECT * FROM users WHERE name = '%s'" % user_input)`.
  - Django ORM: Using user input in `extra()`, `raw()`, or `order_by()`.
- **Command Injection**:
  - User input passed to `subprocess.Popen(..., shell=True)`, `os.system()`, `os.popen()`, or `commands`.
- **Code Execution**:
  - Untrusted data passed to `eval()`, `exec()`, or `compile()`.
- **SSTI (Server-Side Template Injection)**:
  - Rendering user input as template string: Flask `render_template_string(user_input)` or Jinja2 `Template(user_input)`.

## D2: Authentication
- **Session & Token Management**:
  - Django: Missing `@login_required` or `LoginRequiredMixin` on sensitive views.
  - FastAPI: OAuth2 token verification missing expiration check (`exp`).

## D3: Authorization (IDOR)
- **Object Access**:
  - Fetching objects via `Model.objects.get(id=req_id)` without scoping to request user: `Model.objects.get(id=req_id, owner=request.user)`.

## D4: Insecure Deserialization
- **Unsafe Pickle**:
  - `pickle.loads()`, `cPickle.loads()`, or `shelve` operating on untrusted data from network/cookies.
- **Unsafe PyYAML**:
  - Using `yaml.load(data)` without specifying `Loader=yaml.SafeLoader` or calling `yaml.safe_load()`.

## D5: File Operations & Uploads
- **Path Traversal**:
  - `open()`, `os.remove()`, or `send_file()` receiving un-sanitized user input paths.
- **Unrestricted Uploads**:
  - Uploading files without verifying extensions using strict whitelists or storing inside web-accessible root directories.

## D6: SSRF
- **Outbound HTTP**:
  - User-controlled URL passed to `requests.get()`, `urllib.request.urlopen()`, or `httpx.get()` without IP validation against internal/cloud metadata IPs.

## D7: Cryptography & Secrets
- **Hardcoded Secrets**: Storing `SECRET_KEY`, API tokens, or DB passwords directly in `settings.py` or `.py` code files.
- **Weak Randomness**: Using `random.random()` or `random.randint()` for generating secret tokens (use `secrets` module).

## D8: Security Configuration
- **Production Debug Mode**: Django `DEBUG = True` or Flask `app.run(debug=True)` enabled in production environments.
- **CORS Configuration**: `CORSMiddleware` configured with `allow_origins=["*"]` and `allow_credentials=True`.

## D9: Business Logic
- **Mass Assignment**: Mass updating ORM models directly from `request.POST` or Pydantic models without filtering read-only or admin fields.
