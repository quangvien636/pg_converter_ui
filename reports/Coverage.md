# Converter Feature Coverage Report

This report analyzes the database object coverage of the converter, estimating the count and percentage of fully implemented, partially implemented, and unsupported elements for Functions, Procedures, Views, Indexes, and Constraints.

---

## 1. Coverage Inventory Summary

| Object Type | Total Source Count | Implemented (PASS) | Partially Implemented (STUB/FAIL) | Unsupported (Not Loadable) |
|-------------|--------------------|--------------------|-----------------------------------|----------------------------|
| **Functions** | 120 | 11 (9.2%) | 109 (90.8%) | 0 (0.0%) |
| **Procedures**| 2,396 | 0 (0.0%) | 2,380 (99.3%) | 16 (0.7%) |
| **Views** | 8 | 0 (0.0%) | 8 (100.0%) | 0 (0.0%) |
| **Indexes** | 618 | 72 (11.6%) | 15 (2.4%) | 531 (86.0%) |
| **Constraints**| 1,240 | 0 (0.0%) | 1,240 (100.0%)| 0 (0.0%) |
| **TOTAL** | **4,382** | **83 (1.9%)** | **3,752 (85.6%)** | **547 (12.5%)** |

---

## 2. Object Type Analysis

### 1. Functions (120 Total)
* **Implemented (11):** Basic scalar math, string concatenation, and helper functions that compile without error in PostgreSQL.
* **Partially Implemented (109):** Functions containing statement termination syntax issues (`;;`), date parameter default errors (`'GETDATE'`), or local variable name duplication.

### 2. Procedures (2,396 Total)
* **Implemented (0):** Currently, no procedures pass compilation automatically on scale.
* **Partially Implemented (2,380):** Procedures containing transaction controls (`TRAN`), T-SQL cursors, table variables, and dynamic SQL statements.
* **Unsupported (16):** Stored procedures invoking CLR assemblies, replication tasks, or low-level MS-SQL system procedures.

### 3. Views (8 Total)
* **Implemented (0):** Automatic conversion of view bodies is currently not implemented.
* **Partially Implemented (8):** The converter generates a stub comment containing the original CREATE VIEW definition for manual rewrite.

### 4. Indexes (618 Total)
* **Implemented (72):** Non-clustered, single-column and multi-column indexes on supported types are converted and pass syntax checks.
* **Partially Implemented (15):** Indexes with INCLUDE statements or filter conditions that fail standard parsing.
* **Unsupported (531):** Bypassed/not loaded by the database catalog reader due to index-type filtering rules.

### 5. Constraints (1,240 Total)
* **Implemented (0):** Dedicated constraint files are all outputted as stub files.
* **Partially Implemented (1,240):** Bypassed as TODO comments, requiring manual creation of DDL constraint files.
