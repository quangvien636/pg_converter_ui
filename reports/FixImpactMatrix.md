# Fix Impact Matrix

**Reconstructed:** 2026-06-30  
**Purpose:** Separate validated Board/Contact procedure impact from estimated production-catalog impact.

## Completed Procedure-Focused Fixes

| Fix | Board impact | Contact impact | Risk | Evidence / status |
|---|---:|---:|---|---|
| CR/LF and trailing-whitespace normalization | +7 | Baseline established at 107 | Low | `iteration_log.md`; completed |
| Comment shielding, generalized `ELSE BEGIN`, and TOP spacing | Part of +6 combined | Part of +11 combined | Low | `iteration_log.md`, `PostCommit_QA.md`; completed |
| Strip aliases from `UPDATE SET` targets | Part of +6 combined; five named candidates | 0 expected | Low | `ROI_Backlog.md`, `Rank4_Candidate_QA.md`; completed |
| Duplicate parameter/local declaration filter | 0 expected | +8 estimated | Low | Handoffs and regression matrix; implementation/tests are present in pre-existing uncommitted work |
| Inner `ORDER BY` before `UNION` | +4 estimated | 0 | Low | Handoffs/regression matrix report completed |
| Cursor lifecycle conversion | +5 estimated | +1 estimated | Medium | Handoffs/regression matrix report completed |
| XML preparation/`OPENXML` handling | +2 estimated | +1 estimated | Medium | Handoffs/regression matrix report completed |

Validated aggregate movement:

| Suite | Earlier baseline | Latest validated | Delta |
|---|---:|---:|---:|
| NUnit | 20 | 26 | +6 |
| Board% | 140 | 146 | +6 |
| Contact% | 107 | 118 | +11 |

The aggregate deltas must not be added to individual estimates; several fixes were validated together.

## Remaining Production-Catalog Fixes

| Rank | Fix | Estimated object impact | Complexity | ROI | Risk | Target |
|---:|---|---:|---:|---:|---|---|
| 1 | Trim space-padded `sys.objects.type` before classification | +2,396 | 1 | 2,396 | Low | `MssqlDbReader.Load` |
| 2 | Convert standalone constraints | +1,240 | 5 | 248 | Low/medium | `Converter.ConvertConstraint` |
| 3 | Prevent index-name collision bypass across different tables | +531 | 3 | 177 | Low | `MssqlDbReader.LoadIndexes` |
| 4 | Quote reserved identifiers consistently in DML | up to +300 | 4 | 75 | Low/medium | Converter body/identifier mapping |
| 5 | Map `sysname` and `datetimeoffset` | about +50 | 2 | 25 | Low | `Converter.MapType` |
| 6 | Convert view DDL stubs | +8 | 5 | 1.6 | Low/medium | `Converter.ConvertView` |

Constraint and view work was grouped as +1,248 in the handoff backlog; `RemainingFailures.md` breaks that estimate into +1,240 constraints and +8 views.

## Remaining Procedure-Level Candidates

The older candidate reports name dynamic SQL as the largest unresolved Board cluster:

| Candidate | Board estimate | Contact estimate | Complexity | Risk |
|---|---:|---:|---:|---|
| `sp_executesql` parameter substitution / `EXECUTE ... USING` | +6 | +3 | 6 | Medium |
| Temp-table `IDENTITY(1,1)` mapping | +1 | +1 | 2 | Low |

These are historical candidate estimates. The handoff reports subsequently describe broader dynamic-SQL and identity support as tested, so the remaining 16 Board failures must be regrouped from a fresh QA run before treating these estimates as current.

## Recommended Next Rank

The documented highest-ROI unimplemented rank is **production-catalog Rank 1: trim the space-padded object type code in `MssqlDbReader`**. It is a small, low-risk loader correction with the largest stated impact.

For the narrower Board% objective, first rerun Board QA and regroup the current 16 failures. Do not assume the historical dynamic-SQL list is unchanged.
