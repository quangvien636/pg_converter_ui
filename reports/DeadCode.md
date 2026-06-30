# Converter Dead Code & Duplicate Logic Audit

This report reviews the C# converter codebase (`Converter.cs`, `BodyConverter.cs`, `MssqlDbReader.cs`, and `MssqlParser.cs`) for unused methods, duplicate regexes, obsolete parsers, and dead code.

---

## 1. Duplicate Schema Translation Mappings

### 1. Dual Table DDL Converters
* **Locations:**
  * Regex-based: [Converter.cs:642](file:///e:/pg_converter_ui/Converter.cs#L642) (`ConvertTable`)
  * Metadata-based: [Converter.cs:1317](file:///e:/pg_converter_ui/Converter.cs#L1317) (`ConvertTableFromCatalog`)
* **Duplication:** Both functions map MSSQL types to PostgreSQL types (`serial`, `uuid`, `boolean`, `numeric`), quote reserved words, and handle default constraints. However, they use separate mapping methods: `ConvertTable` uses flat regex swaps on raw SQL text, while `ConvertTableFromCatalog` uses `MapCatalogType` on metadata structures. This duplicate implementation leads to inconsistent DDL outputs (e.g. key checks differ between the two paths).

---

## 2. Redundant / Unused Logic Elements

### 1. Hardcoded Connection String Defaults in `MssqlDbReader.cs`
* **Location:** [MssqlDbReader.cs:12](file:///e:/pg_converter_ui/MssqlDbReader.cs#L12)
* **Redundancy:** The connection timeout parameters (`Connect Timeout=15`) are hardcoded directly into `BuildConnectionString`. They duplicate default values configured in `Form1.cs` textboxes and cannot be adjusted by the user in the UI.

### 2. Commented Debug Prints in `Form1.cs`
* **Location:** [Form1.cs:399-432](file:///e:/pg_converter_ui/Form1.cs#L399)
* **Dead Code:** Multiple debug print lines and commented-out window layout properties exist in the WinForms UI builder methods, representing legacy debugging overhead that should be cleaned up.

---

## 3. General Recommendations
1. **Unify Table DDL Mapping:** Merge the mapping logic of `ConvertTable` and `ConvertTableFromCatalog` into a single helper class to ensure type conversions and constraints behave identically regardless of whether they are parsed from SQL files or loaded from active database catalogs.
2. **Exclusion of intermediate folders:** Explicitly configure test folders in `.csproj` files to prevent global compilation issues.
