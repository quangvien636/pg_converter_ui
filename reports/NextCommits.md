# Next Commits Roadmap

This document outlines the next 10 development commits prioritized by ROI to guide step-by-step implementation.

---

## Commit 1
*   **Objective:** Fix MS SQL Stored Procedure type classification.
*   **Files to Modify:** [MssqlDbReader.cs](file:///e:/pg_converter_ui/MssqlDbReader.cs)
*   **Expected PASS Increase:** **+2,396** procedures correctly classified and processed.
*   **Risk:** Low (requires trimming strings returned from catalog queries).

## Commit 2
*   **Objective:** Implement View DDL translation parsing.
*   **Files to Modify:** [Converter.cs](file:///e:/pg_converter_ui/Converter.cs) (`ConvertView`)
*   **Expected PASS Increase:** **+8** view objects.
*   **Risk:** Low (converts select query text by stripping SQL Server decorators).

## Commit 3
*   **Objective:** Implement Constraint DDL translation.
*   **Files to Modify:** [Converter.cs](file:///e:/pg_converter_ui/Converter.cs) (`ConvertConstraint`)
*   **Expected PASS Increase:** **+1,248** constraints (primary, foreign, check keys, default values).
*   **Risk:** Low (maps check, default, and alter queries to PostgreSQL syntax).

## Commit 4
*   **Objective:** Resolve Index Name Collision Loader check logic.
*   **Files to Modify:** [MssqlDbReader.cs](file:///e:/pg_converter_ui/MssqlDbReader.cs) (`LoadIndexes` queries)
*   **Expected PASS Increase:** **+531** index objects loaded and verified.
*   **Risk:** Low (checks combined table name and index name uniqueness).

## Commit 5
*   **Objective:** Support datatype mapping for `sysname` and `datetimeoffset` types.
*   **Files to Modify:** [Converter.cs](file:///e:/pg_converter_ui/Converter.cs) (`MapType`)
*   **Expected PASS Increase:** **+50** routines compile successfully.
*   **Risk:** Low (maps types to standard varchar and timestamptz respectively).

## Commit 6
*   **Objective:** Implement quote-guarding identifier check for reserved keywords in DML.
*   **Files to Modify:** [Converter.cs](file:///e:/pg_converter_ui/Converter.cs) (`ConvertBody`)
*   **Expected PASS Increase:** **+300** syntax compiler errors fixed.
*   **Risk:** Medium (requires robust regex mapping to prevent double quoting).

## Commit 7
*   **Objective:** Add automatic conversion for standard `LEN` function to `LENGTH`.
*   **Files to Modify:** [Converter.cs](file:///e:/pg_converter_ui/Converter.cs) / [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs)
*   **Expected PASS Increase:** **+50** routine blocks compile successfully.
*   **Risk:** Low (standard string substitution regex).

## Commit 8
*   **Objective:** Map interval arguments for date arithmetic function `DATEADD`.
*   **Files to Modify:** [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs)
*   **Expected PASS Increase:** **+40** routine blocks compile successfully.
*   **Risk:** Medium (requires complex parsing of dates, units, and intervals).

## Commit 9
*   **Objective:** Clean up error tracking and row count variables (`@@ERROR` / `@@ROWCOUNT`).
*   **Files to Modify:** [Converter.cs](file:///e:/pg_converter_ui/Converter.cs) (`ConvertBody`)
*   **Expected PASS Increase:** **+20** objects.
*   **Risk:** Low (replaces system tokens with equivalent PL/pgSQL constructs).

## Commit 10
*   **Objective:** Implement parameter bindings for native PostgreSQL `XMLTABLE` mappings.
*   **Files to Modify:** [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs)
*   **Expected PASS Increase:** **+3** procedures.
*   **Risk:** Medium (requires structural mapping of XML namespaces and query elements).
