# Deep C# & .NET Language Security Guide

## 1. Unsafe Deserialization (`BinaryFormatter`)
`System.Runtime.Serialization.Formatters.Binary.BinaryFormatter` is inherently insecure and cannot be made safe. Deserializing data from untrusted sources enables Remote Code Execution via gadget chains (e.g. `ObjectDataProvider`, `FileSystemUtils`).

```csharp
// ❌ Dangerous: BinaryFormatter deserialization
BinaryFormatter formatter = new BinaryFormatter();
object data = formatter.Deserialize(untrustedStream); // RCE risk!

// ✓ Secure: Use System.Text.Json or Newtonsoft.Json without TypeNameHandling.All
var data = JsonSerializer.Deserialize<UserData>(untrustedJsonString);
```

---

## 2. TypeNameHandling in Newtonsoft.Json
Configuring `TypeNameHandling` to `All` or `Auto` allows attackers to specify arbitrary .NET types in JSON (`"$type": "System.Windows.Data.ObjectDataProvider, ..."`).

```csharp
// ❌ Dangerous: TypeNameHandling enabled
var settings = new JsonSerializerSettings {
    TypeNameHandling = TypeNameHandling.All // Allows arbitrary type instantiation!
};
var obj = JsonConvert.DeserializeObject(jsonString, settings);

// ✓ Secure: Keep TypeNameHandling disabled (default is TypeNameHandling.None)
var obj = JsonConvert.DeserializeObject<UserData>(jsonString);
```

---

## 3. Entity Framework Raw SQL Injection
While LINQ queries are parameterized automatically, Entity Framework methods like `FromSqlRaw` and `ExecuteSqlRaw` concatenate string variables directly into SQL statements unless string interpolation is passed to `FromSqlInterpolated`.

```csharp
// ❌ Dangerous: String concatenation in FromSqlRaw
string query = "SELECT * FROM Users WHERE Name = '" + userInput + "'";
var users = context.Users.FromSqlRaw(query).ToList(); // SQL Injection!

// ✓ Secure: Use FromSqlInterpolated or explicit DbParameter objects
var users = context.Users.FromSqlInterpolated($"SELECT * FROM Users WHERE Name = {userInput}").ToList();
```

---

## 4. XML External Entity (XXE) Processing
In older .NET Framework versions (< 4.5.2), `XmlDocument` and `XmlTextReader` resolve DTD external entities by default.

```csharp
// ❌ Dangerous: DTD Processing Enabled
XmlDocument xmlDoc = new XmlDocument();
xmlDoc.LoadXml(untrustedXml); // Reads local files via <!ENTITY xxe SYSTEM "file:///c:/boot.ini">

// ✓ Secure: Set DtdProcessing to Prohibit or Ignore
XmlReaderSettings settings = new XmlReaderSettings();
settings.DtdProcessing = DtdProcessing.Prohibit;
using (XmlReader reader = XmlReader.Create(stream, settings)) {
    // Safe XML parsing
}
```
