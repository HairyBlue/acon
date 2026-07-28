# JavaScript / Node.js & TypeScript Security Checklist

## D1: Injection
- **SQL / Query Injection**:
  - Template literals in raw queries: `` sequelize.query(`SELECT * FROM users WHERE id = ${req.query.id}`) `` or `knex.raw()`.
- **NoSQL Injection**:
  - Passing un-sanitized request objects directly to MongoDB/Mongoose: `db.users.find(req.body)` allowing operator injection (`"$gt": ""`, `"$where"`).
- **Code Execution**:
  - User input passed to `eval()`, `new Function()`, `vm.runInNewContext()`, or `vm.runInThisContext()`.
- **Command Injection**:
  - User input concatenated inside `child_process.exec()` or `child_process.execSync()`.
- **ReDoS (Regular Expression DoS)**:
  - Constructing regex from user input (`new RegExp(req.query.pattern)`) with catastrophic backtracking patterns.

## D2: Authentication
- **Broken JWT Verification**:
  - Calling `jwt.decode()` instead of `jwt.verify()`.
  - Allowing `algorithms: ["none"]` in `jsonwebtoken` verification options.
- **Insecure Cookies**:
  - Auth cookies missing `httpOnly: true`, `secure: true`, or `sameSite: 'lax'|'strict'` flags.

## D3: Authorization (IDOR)
- **Object Ownership**:
  - Fetching records via `Model.findById(req.params.id)` without checking if `userId` matches `req.user.id`.
- **Missing Middleware**:
  - REST endpoints or GraphQL mutations missing authentication or role authorization guards.

## D4: Prototype Pollution & Deserialization
- **Prototype Pollution**:
  - Merging user objects using `Object.assign()`, `lodash.merge()`, or `defaultsDeep()` without blocking `__proto__`, `constructor`, or `prototype` keys.
- **Unsafe Yaml / Serialization**:
  - `js-yaml.load()` operating on untrusted input using `DEFAULT_SCHEMA` instead of `JSON_SCHEMA` or `FAILSAFE_SCHEMA`.
  - Unsafe deserialization using `node-serialize` or `cryo` (enabling RCE via IIFE payload execution).

## D5: File Operations & Path Traversal
- **Path Traversal**:
  - Passing user input directly to `fs.readFile()`, `fs.unlink()`, or `res.sendFile()` without sanitizing `path.normalize()` or checking base directory boundaries.
- **Zip Slip**:
  - Extracting zip archives without checking if entry filenames resolve outside the target extraction path.

## D6: SSRF
- **Outbound HTTP**:
  - User-supplied URL passed directly to `axios.get()`, `fetch()`, or `request()` without blocking metadata endpoints (`169.254.169.254`) or local addresses (`127.0.0.1`, `localhost`).

## D7: Cryptography & Secrets
- **Hardcoded Secrets**: Hardcoding JWT secrets, API keys, or Session secrets in source files instead of `process.env`.
- **Weak Randomness**: Using `Math.random()` for generating tokens or session IDs (use `crypto.randomBytes()`).

## D8: Security Configuration
- **Permissive CORS**: Configuring `cors({ origin: '*' })` combined with `credentials: true`.
- **Exposed Errors**: Returning full error stack traces (`err.stack`) in Express / Fastify / Next.js production error handlers.

## D9: Business Logic
- **Mass Assignment**: Passing `req.body` directly to `Model.create(req.body)` or `Model.update(req.body)` without whitelisting parameters.
