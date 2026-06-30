# Missing Features and Unimplemented Converter Logic Report

This report documents the features, keywords, and patterns in Microsoft SQL Server that are currently not implemented or fall back to `TODO` placeholders in the C# converter codebase.

---

## 1. Summary of Missing Features

| Feature | MSSQL Syntax | Converter Behavior / Output | Source File & Line |
|---------|--------------|-----------------------------|--------------------|
| **Constraint Objects** | `ALTER TABLE ADD CONSTRAINT ...` | Commented stub:<br>`-- TODO: constraint conversion not implemented for: {obj.Name}` | [Converter.cs:812](file:///e:/pg_converter_ui/Converter.cs#L812) |
| **View WITH ENCRYPTION** | `CREATE VIEW ... WITH ENCRYPTION` | Bypassed stub:<br>`-- TODO: view [{Name}] uses WITH ENCRYPTION — cannot convert automatically.` | [Converter.cs:832](file:///e:/pg_converter_ui/Converter.cs#L832) |
| **MERGE Statement** | `MERGE INTO Target USING Source ...` | Bypassed stub:<br>`-- TODO: MERGE requires PostgreSQL 15+ — review syntax before running:` | [BodyConverter.cs:579](file:///e:/pg_converter_ui/BodyConverter.cs#L579) |
| **Linked Server (OPENROWSET)** | `OPENROWSET('provider', 'datasource', ...)` | Bypassed stub:<br>`NULL -- TODO: OPENROWSET → use postgres_fdw or dblink` | [BodyConverter.cs:602](file:///e:/pg_converter_ui/BodyConverter.cs#L602) |
| **Linked Server (OPENQUERY)** | `OPENQUERY(LinkedServer, 'query')` | Template replacement:<br>`dblink('TODO_CONN_{server}', {quoted})` | [BodyConverter.cs:590](file:///e:/pg_converter_ui/BodyConverter.cs#L590) |
| **Parameterized sp_executesql**| `EXEC sp_executesql @stmt, @params, ...`| Inline comment:<br>`EXECUTE {sqlVar}; -- TODO: parameterized sp_executesql` | [BodyConverter.cs:486](file:///e:/pg_converter_ui/BodyConverter.cs#L486) |
| **NEWID() Generator** | `DEFAULT NEWID()` | Commented warning:<br>`-- TODO: NEWID() requires manual rewrite or uuid-ossp extension on PostgreSQL 9.3.` | [Converter.cs:722](file:///e:/pg_converter_ui/Converter.cs#L722) |
| **Clustered Indexes** | `CREATE CLUSTERED INDEX ...` | Commented warning:<br>`-- TODO: SQL Server CLUSTERED index detected. PostgreSQL does not maintain clustered indexes the same way.` | [Converter.cs:762](file:///e:/pg_converter_ui/Converter.cs#L762) |
| **Dynamic Column Definition**| Missing view/function column definitions | Placeholder:<br>`-- TODO: list col defs (name type, ...)` | [BodyConverter.cs:614](file:///e:/pg_converter_ui/BodyConverter.cs#L614) |
| **SETOF Record Returns** | Dynamic record-returning SELECT statements | Placeholder:<br>`-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually` | [Converter.cs:108](file:///e:/pg_converter_ui/Converter.cs#L108) |

---

## 2. Detailed Breakdown of Key Unimplemented Features

### 1. View Conversion Limitations
* **Source:** [Converter.cs:832](file:///e:/pg_converter_ui/Converter.cs#L832)
* **Risk:** SQL Server views created `WITH ENCRYPTION` do not expose their body definition in system tables, rendering automatic translation impossible. The converter flags this with an warning but outputs no conversion code.

### 2. Standalone Constraints
* **Source:** [Converter.cs:812](file:///e:/pg_converter_ui/Converter.cs#L812)
* **Risk:** Constraints (Primary Keys, Foreign Keys, Unique Constraints, Default Constraints) created outside of `CREATE TABLE` blocks are generated as commented-out stubs. Since the table generator also skips identity primary keys, this leads to target schemas containing tables without indexes or primary/foreign key validation.

### 3. Linked Server Query Bypasses
* **Source:** [BodyConverter.cs:590-605](file:///e:/pg_converter_ui/BodyConverter.cs#L590)
* **Risk:** `OPENQUERY` and `OPENROWSET` rely on SQL Server database links. In PostgreSQL, these must be mapped to `postgres_fdw` (Foreign Data Wrappers) or `dblink` connection parameters. The converter outputs template helpers containing `TODO_CONN` string identifiers that must be manually configured in the destination database.

### 4. Parameterized Dynamic SQL
* **Source:** [BodyConverter.cs:486](file:///e:/pg_converter_ui/BodyConverter.cs#L486)
* **Risk:** PostgreSQL's `EXECUTE` command handles parameter bindings via the `USING` clause (e.g. `EXECUTE query USING param1, param2`). The converter currently does not translate `sp_executesql` parameters into `USING` clauses, outputting a standard `EXECUTE {sqlVar}` statement followed by a warning comment, which will fail if parameter arguments are passed.
