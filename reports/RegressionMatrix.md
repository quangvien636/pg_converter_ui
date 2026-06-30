# Regression Validation Matrix

This document maps implemented features to their corresponding regression unit tests and documents their PASS/FAIL compilation status.

---

## NUnit Regression Test Suite

All 26 tests compile and execute successfully.

| Feature Area | NUnit Regression Test | Target Converter Function | PASS | FAIL |
|---|---|---|:---:|:---:|
| **Carriage Return Lookbehinds** | `TestCarriageReturnDoubleSemicolon` | `Converter.Convert` / `BodyConverter.Convert` | **YES** | -- |
| **Transaction Control** | `TestUnconvertedTransaction` | `BodyConverter.Convert` (Transaction strip block) | **YES** | -- |
| **Date Default Value** | `TestGetDateParameterDefault` | `Converter.MapDefault` | **YES** | -- |
| **Comments in Param Block** | `TestParameterBlockComment` | `Converter.ConvertParams` | **YES** | -- |
| **Reserved Keyword Quoting** | `TestReservedWordPosition` | `Converter.QuoteIfReserved` / `PgReservedWords` | **YES** | -- |
| **T-SQL Cursor Loops** | `TestUnconvertedCursor` | `BodyConverter.ConvertCursors` | **YES** | -- |
| **Union Order By** | `TestUnionOrderBy` | `BodyConverter.Convert` (Union order by strip block) | **YES** | -- |
| **XML Processing (OPENXML)** | `TestXMLOpenXML` | `BodyConverter.ConvertExec` (XML handling blocks) | **YES** | -- |
| **Inline Comments in IF** | `TestCommentShieldingIfThen` | `BodyConverter.ConvertControlFlow` | **YES** | -- |
| **Inline Comments in WHILE** | `TestCommentShieldingWhileLoop` | `BodyConverter.ConvertControlFlow` | **YES** | -- |
| **UPDATE SET Alias Stripping** | `TestUpdateSetAliasStrip` | `BodyConverter.ConvertAssignments` | **YES** | -- |
| **UPDATE SET Right Side Preservation** | `TestUpdateSetAliasRightSidePreserved` | `BodyConverter.ConvertAssignments` | **YES** | -- |
| **Duplicate Param/Var Filter** | `TestDuplicateParamVarDeclarationFiltered` | `Converter.ConvertProcedure` / `ConvertFunction` | **YES** | -- |
| **Non-Duplicate Declares Kept** | `TestNonDuplicateDeclareKept` | `Converter.ConvertProcedure` / `ConvertFunction` | **YES** | -- |
| **TOP Clause** | `TestTOP` (in `UnsupportedFeaturesTests`) | `Converter.ConvertBody` / `BodyConverter.NormalizeBoardTop` | **YES** | -- |
| **OUTPUT Clause** | `TestOUTPUT` (in `UnsupportedFeaturesTests`) | `Converter.ConvertParams` / `BodyConverter.Convert` | **YES** | -- |
| **MERGE Statement** | `TestMERGE` (in `UnsupportedFeaturesTests`) | `BodyConverter.ConvertMerge` | **YES** | -- |
| **RAISERROR** | `TestRAISERROR` (in `UnsupportedFeaturesTests`) | `BodyConverter.ConvertRaiseError` | **YES** | -- |
| **TRY/CATCH Blocks** | `TestTRY_CATCH` (in `UnsupportedFeaturesTests`) | `BodyConverter.ConvertTryCatch` | **YES** | -- |
| **Cursor Lifecycles** | `TestCURSOR` (in `UnsupportedFeaturesTests`) | `BodyConverter.ConvertCursors` | **YES** | -- |
| **XML Shredding** | `TestXML` (in `UnsupportedFeaturesTests`) | `BodyConverter.ConvertExec` | **YES** | -- |
| **IDENTITY Column DDL** | `TestIDENTITY` (in `UnsupportedFeaturesTests`) | `Converter.ConvertTable` / `BodyConverter.ConvertTempTables` | **YES** | -- |
| **Table Variables** | `TestTableVariables` (in `UnsupportedFeaturesTests`) | `BodyConverter.ConvertTempTables` / `ConvertBoardTempTables` | **YES** | -- |
| **Dynamic SQL (sp_executesql)** | `TestDynamicSQL` (in `UnsupportedFeaturesTests`) | `BodyConverter.ConvertExec` | **YES** | -- |
| **Temp Tables (#tmp)** | `TestTempTables` (in `UnsupportedFeaturesTests`) | `BodyConverter.ConvertTempTables` / `ConvertBoardTempTables` | **YES** | -- |
| **Recursive CTE** | `TestRecursiveCTE` (in `UnsupportedFeaturesTests`) | `BodyConverter.ReorderBoardCteTempMaterialization` | **YES** | -- |

---

## Board QA Integration Regression Suite

All 24 representative procedures pass integration testing.

| Procedural Case | Regression Assertion | Target Function | PASS | FAIL |
|---|---|---|:---:|:---:|
| **END/ELSE Block** | `endElse` (semicolon spacing) | `qa/BoardRegressionTests/Program.cs` | **YES** | -- |
| **INSERT SELECT Result** | `dmlResult` | `qa/BoardRegressionTests/Program.cs` | **YES** | -- |
| **Inline IF Block** | `inlineIf` | `qa/BoardRegressionTests/Program.cs` | **YES** | -- |
| **SELECT TOP Assignment** | `selectAssignment` | `qa/BoardRegressionTests/Program.cs` | **YES** | -- |
| **Dynamic TOP Clause** | `dynamicTop` | `qa/BoardRegressionTests/Program.cs` | **YES** | -- |
| **Board OUTER APPLY** | `outerApply` (LEFT JOIN LATERAL mapping) | `qa/BoardRegressionTests/Program.cs` | **YES** | -- |
| **Nested ELSE BEGIN** | `nestedElseBegin` | `qa/BoardRegressionTests/Program.cs` | **YES** | -- |
| **Nested IF Block** | `nestedIf` | `qa/BoardRegressionTests/Program.cs` | **YES** | -- |
| **String Accumulation** | `stringAccumulation` | `qa/BoardRegressionTests/Program.cs` | **YES** | -- |
| **Temp Table Lifecycle** | `tempLifecycle` | `qa/BoardRegressionTests/Program.cs` | **YES** | -- |
| **Table Variables** | `tableVariable` | `qa/BoardRegressionTests/Program.cs` | **YES** | -- |
| **Statement Boundaries** | `statementBoundaries` | `qa/BoardRegressionTests/Program.cs` | **YES** | -- |
| **Control Boundaries** | `controlBoundaries` | `qa/BoardRegressionTests/Program.cs` | **YES** | -- |
| **SQL CASE Boundaries** | `sqlCaseBoundary` | `qa/BoardRegressionTests/Program.cs` | **YES** | -- |
| **INSERT SELECT Boundaries** | `insertSelectBoundary` | `qa/BoardRegressionTests/Program.cs` | **YES** | -- |
| **Scalar Convert Assignment** | `scalarConvertAssignment` | `qa/BoardRegressionTests/Program.cs` | **YES** | -- |
| **Consecutive Scalar Selects** | `consecutiveScalarSelects` | `qa/BoardRegressionTests/Program.cs` | **YES** | -- |
| **Multiline Scalar Select** | `multilineScalarSelect` | `qa/BoardRegressionTests/Program.cs` | **YES** | -- |
| **Bare END IF Closure** | `bareEndIf` | `qa/BoardRegressionTests/Program.cs` | **YES** | -- |
| **Missing END IF Closure** | `missingEndIf` | `qa/BoardRegressionTests/Program.cs` | **YES** | -- |
| **CTE Temp Materialization** | `cteTempMaterialization` | `qa/BoardRegressionTests/Program.cs` | **YES** | -- |
| **Balanced Temp Columns** | `balancedTableDefinition` | `qa/BoardRegressionTests/Program.cs` | **YES** | -- |
| **Temp Table IDENTITY** | `tempIdentity` | `qa/BoardRegressionTests/Program.cs` | **YES** | -- |
| **Temp Drop Guard** | `tempDropGuard` | `qa/BoardRegressionTests/Program.cs` | **YES** | -- |
