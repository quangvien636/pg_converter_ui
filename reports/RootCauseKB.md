# Root Cause Knowledge Base

**Reconstructed:** 2026-06-30  
**Target dialect:** PostgreSQL 9.3 compatibility.

## RC-01: Carriage Returns Shield Statement Terminator Checks

- Symptom: doubled semicolons or malformed statement boundaries.
- Cause: regex lookbehinds inspect `\r` or trailing whitespace instead of the existing terminator.
- Fix: normalize CRLF/CR to LF and trim end-of-line spaces before body transformations.
- Regression: `TestCarriageReturnDoubleSemicolon`.
- Status: implemented and validated.

## RC-02: Trailing Comments Hide Required Block Keywords

- Symptom: missing `THEN` / `LOOP`, then syntax errors near `ELSE` or `ELSIF`.
- Cause: appending the keyword after `--` makes it comment text.
- Fix: split the trailing comment and emit the keyword before it.
- Regressions: `TestCommentShieldingIfThen`, `TestCommentShieldingWhileLoop`.
- Status: implemented and validated.

## RC-03: T-SQL `ELSE BEGIN` Produces Unbalanced PL/pgSQL

- Symptom: literal `BEGIN`, unclosed IF blocks, or missing branch terminators.
- Cause: T-SQL grouping tokens were retained after PL/pgSQL branch conversion.
- Fix: suppress the branch `BEGIN` and ensure the preceding branch statement is terminated.
- Status: implemented and validated for Board and Contact.

## RC-04: Target Aliases Are Illegal in PostgreSQL `UPDATE SET`

- Symptom: syntax error at the dot in `SET BW.Sort = ...`.
- Cause: PostgreSQL does not permit target-column qualification on the left side of assignments.
- Fix: remove only left-hand target aliases; preserve right-side references.
- Regressions: `TestUpdateSetAliasStrip`, `TestUpdateSetAliasRightSidePreserved`.
- Status: implemented and validated.

## RC-05: Parameters Are Redeclared as Local Variables

- Symptom: duplicate variable declaration during PL/pgSQL compilation.
- Cause: T-SQL uses the same `@name` notation for parameters and locals; both were emitted.
- Fix: compare declarations case-insensitively with parameter names and remove only duplicates.
- Regressions: `TestDuplicateParamVarDeclarationFiltered`, `TestNonDuplicateDeclareKept`.
- Status: present in pre-existing uncommitted converter/test work; reported passing.

## RC-06: Inner `ORDER BY` Appears Before `UNION`

- Symptom: syntax error near `UNION`.
- Cause: SQL Server accepts branch ordering forms PostgreSQL rejects without parentheses.
- Fix: remove the branch-local ordering immediately before `UNION`; retain final ordering.
- Regression: `TestUnionOrderBy`.
- Status: reported implemented and passing.

## RC-07: Cursor Lifecycle Syntax Is SQL Server-Specific

- Symptom: raw `OPEN`, `FETCH NEXT`, `CLOSE`, or `DEALLOCATE`; invalid loop variables.
- Cause: direct cursor lifecycle translation is not valid PL/pgSQL.
- Fix: convert the cursor query/body to a PL/pgSQL row loop with mapped assignments.
- Regressions: `TestUnconvertedCursor`, `TestCURSOR`.
- Status: reported implemented and passing.

## RC-08: Proprietary XML Shredding Does Not Compile

- Symptom: syntax error near `EXEC` or `OPENXML`.
- Cause: `sp_xml_preparedocument` and `OPENXML` are SQL Server-only.
- Fix: remove document-handle setup safely and translate supported shredding to `XMLTABLE`, otherwise emit an explicit TODO stub.
- Regressions: `TestXMLOpenXML`, `TestXML`.
- Status: reported implemented/tested; semantic completeness still requires runtime scrutiny.

## RC-09: Space-Padded Catalog Type Misclassifies Procedures

- Symptom: stored procedures take the wrong conversion path in production-catalog loading.
- Cause: `sys.objects.type` is `char(2)` and may return `"P "` while code compares with `"P"`.
- Fix: trim the type string at the reader boundary before classification.
- Expected impact: +2,396 production-catalog objects.
- Risk: low.
- Status: highest-ROI documented remaining rank; not implemented in this step.

## RC-10: Standalone Views and Constraints Are Emitted as Stubs

- Symptom: converted objects are TODO comments rather than executable DDL.
- Cause: `ConvertView` and `ConvertConstraint` lack full SQL Server-to-PostgreSQL mappings.
- Fix: translate view decorators/hints and emit valid `ALTER TABLE ... ADD CONSTRAINT` forms.
- Expected impact: 8 views and 1,240 constraints.
- Status: remaining.

## RC-11: Index Names Collide Across Tables

- Symptom: valid indexes are silently bypassed.
- Cause: loader uniqueness checks use schema-wide index name alone rather than table plus index identity.
- Fix: include table identity in metadata lookup/deduplication.
- Expected impact: +531 production objects.
- Status: remaining.

## RC-12: SQL Server-Only Types Reach PostgreSQL

- Symptom: type `sysname` or `datetimeoffset` does not exist.
- Cause: missing mappings in `MapType`.
- Fix: `sysname` to `varchar(128)`; `datetimeoffset` to `timestamp with time zone`.
- Status: remaining.

## RC-13: Dynamic SQL Needs Parameterized PL/pgSQL Execution

- Symptom: raw `sp_executesql`, broken concatenation, or invalid `EXEC`.
- Cause: SQL Server parameter-definition strings and named assignments do not map directly to PL/pgSQL.
- Fix direction: emit `EXECUTE expression USING ...`, preserving parameter order and safe quoting.
- Historical estimate: six Board and three Contact procedures.
- Status: historical candidate; fresh QA regrouping is required because later reports claim dynamic-SQL regression coverage.

## Guardrails

- Never repair generated SQL directly.
- Apply converter changes at the narrowest responsible transformation stage.
- Protect regex operations with timeouts.
- Add a focused regression for both the failing form and a nearby non-failing form.
- Validate build, NUnit, Board%, and regression deltas before committing one rank.
