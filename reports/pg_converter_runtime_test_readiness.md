# pg_converter_runtime_test Readiness Report

## Executive Summary

* Overall status: NEED VERIFICATION
* MSSQL source checked: Yes (read-only catalog)
* Bootstrap PGSQL checked: Yes (read-only catalog)
* Runtime test DB created/updated: No
* Schema match confidence: Low
* Data safety risk: Low for this read-only pass
* Can run converted procedure validation: Partial

## Source Databases

| Database | Role | Modified? | Notes |
|---|---|---|---|
| MSSQL source | Source of truth | No | Catalog snapshot only |
| crewcloud_company_bootstrap_test | PGSQL reference | No | Not assumed correct |
| pg_converter_runtime_test | Runtime validation target | No | Snapshot taken before any proposed change |

## Schema Diff Summary

| Object Type | MSSQL Count | Bootstrap PG Count | Runtime Test Count | Missing | Extra | Different |
|---|---:|---:|---:|---:|---:|---:|
| Tables | 705 | 462 | 667 | NEED VERIFICATION | NEED VERIFICATION | NEED VERIFICATION |
| Views | 8 | 86 | 0 | NEED VERIFICATION | NEED VERIFICATION | NEED VERIFICATION |
| Routines | 2516 | 1910 | 866 | NEED VERIFICATION | NEED VERIFICATION | NEED VERIFICATION |
| Sequences | 0 | 345 | 468 | NEED VERIFICATION | NEED VERIFICATION | NEED VERIFICATION |
| All catalog objects | 4441 | 2803 | 2001 | 2908 | 468 | NEED VERIFICATION |

## Critical Differences

| Object | Difference | Impact | Required Action |
|---|---|---|---|
| Runtime schema | 2908 MSSQL names absent | Runtime dependencies may remain blocked | Review canonical mapping before patch |
| Bootstrap reference | 2362 MSSQL names absent | Reference is not proven complete | Review type/constraint/logic differences |
| Seed data | Not compared | Runtime calls may return empty or fail | Classify and mask required reference rows |

## Runtime Test Build Actions

| Step | Script | Result | Notes |
|---|---|---|---|
| 1 | `001_create_pg_converter_runtime_test.sql` | REVIEW ONLY | No DROP/recreate performed |
| 2 | `002_schema_patch_from_mssql_diff.sql` | BLOCKED | Semantic mapping review required |
| 3 | `003_required_seed_or_reference_data.sql` | BLOCKED | Data classification required |

## Converted Procedure Validation

| Module | Total | Compile PASS | Runtime PASS | FAIL | BLOCKED | NEED DATA |
|---|---:|---:|---:|---:|---:|---:|
| Board + Contact | 351 | 351 | 82 | 180 | 89 | Not separately classified |

## Final Decision

`pg_converter_runtime_test` is **not yet schema-ready** for authoritative converter
assessment. It remains useful for partial rollback-only runtime validation. No
production-safety or business-equivalence claim is made.