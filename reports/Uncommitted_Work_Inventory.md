# Uncommitted Work Inventory

**Snapshot date:** 2026-06-30  
**Branch / HEAD:** `master` / `3cace89`  
**Preservation rule:** This inventory records the pre-existing worktree. Nothing was reset, overwritten, staged, or committed.

## Safety Snapshot

- `git status --short`: 66 modified files and 132 untracked files before this inventory and the three regenerated handoff reports were created.
- `git diff --stat`: 66 tracked files changed, 676 insertions, 685 deletions.
- `git log --oneline -10`: four commits exist; HEAD is `3cace89 Implement ROI Ranks 1+2: comment shielding, ELSE BEGIN fix, UPDATE SET alias strip`.
- Deleted files: none.
- Renamed files: none.
- Staged files: none.

## Assessment

The entire workset is treated as intentional prior/user work unless later evidence proves otherwise. The converter change, matching regression tests, refreshed validation totals, regenerated Board SQL, Contact failure corpus, QA tooling, and handoff documents form a coherent converter-analysis session. Ownership cannot be proven from Git metadata, so none of these changes may be reset, checked out, cleaned, stashed, overwritten, or included in a future implementation commit without explicit approval and deliberate separation.

The lone `$null` untracked file is unusual, but its name alone is not proof that it is accidental. It is classified as intentional prior work and has been preserved.

## Modified Files

| Files | Category | Likely owner / purpose | Intentional? |
|---|---|---|---|
| `Converter.cs` | Converter source | Prior implementation of duplicate parameter/local-variable filtering for procedures and functions | Yes; paired with tests |
| `tests/Regression/RegressionTests.cs` | Tests | Adds duplicate-declaration and non-duplicate preservation tests | Yes; paired with converter change |
| `reports/Board_Procedure_Validation.md` | Report | Refreshes Board validation timestamp | Yes |
| `reports/Contact_Procedure_Validation.md` | Report | Refreshes Contact validation timestamp | Yes |
| `reports/PostCommit_QA.md` | Report | Refreshes HEAD, NUnit 26/26, Board 146/162, Contact 118/189 | Yes |
| `reports/board_failing_sql/*.sql` (61 tracked files listed below) | Generated SQL | Regenerated Board failure artifacts after converter changes | Yes; generated, not hand-edited source |

### Modified Board generated SQL (61)

`Board_CheckPermission.sql`, `Board_DeleteNotificationService.sql`, `Board_DownBoard.sql`,
`Board_DownBoardByUser.sql`, `Board_DownFolder.sql`, `Board_DownFolderByUser.sql`,
`Board_DownMultilWidget.sql`, `Board_DownMultiWidget.sql`, `Board_DownWidget.sql`,
`Board_GetAllBoardContents.sql`, `Board_GetAllBoardContentsByBoardList.sql`,
`Board_GetAndroidDeviceOfUsersByDepartment.sql`, `Board_GetBoardContents.sql`,
`Board_GetBoardContents_BK20181227.sql`, `Board_GetBoards.sql`, `Board_GetBoards_BK.sql`,
`Board_GetBoards_Improved.sql`, `Board_GetCurrentManagerList.sql`,
`Board_GetDepartAndPositionName.sql`, `Board_GetHeads.sql`,
`Board_GetIOSDeviceOfUsersByDepartment.sql`, `Board_GetListNoticePermission.sql`,
`Board_GetListUserPermission.sql`, `Board_GetListUserPermissionToExcel.sql`,
`Board_GetPreNextContent.sql`, `Board_GetReplyByContent.sql`, `Board_GetSubMenus.sql`,
`Board_GetTreeSubMenu_V2.sql`, `Board_GetTreeSubMenu_V2_Json.sql`,
`Board_GetUserByShare.sql`, `Board_InsertAndroidDevice.sql`, `Board_InsertBoardContent.sql`,
`Board_InsertCurrentManager.sql`, `Board_InsertDepartAllowAccess.sql`,
`Board_InsertFile.sql`, `Board_InsertIOSDevice.sql`, `Board_InsertNotificationService.sql`,
`Board_InsertRecommendedLog.sql`, `Board_InsertReply.sql`, `Board_InsertReplyFile.sql`,
`Board_InsertUserSetting.sql`, `Board_InsertViewedLog.sql`, `Board_Mobile_Search.sql`,
`Board_SetFolders.sql`, `Board_SetShare.sql`, `Board_UpBoard.sql`,
`Board_UpBoardByUser.sql`, `Board_UpFolder.sql`, `Board_UpFolderByUser.sql`,
`Board_UpMultiWidget.sql`, `Board_UpWidget.sql`, `Board_UpdateConfig.sql`,
`Board_UpdateDepartAllowAccess.sql`, `Board_UpdateFile.sql`, `Board_UpdateFolder.sql`,
`Board_UpdateLevelRand.sql`, `Board_UpdateNoticePermission.sql`,
`Board_UpdateNotificationService.sql`, `Board_UpdateRecommendPublic.sql`,
`Board_UpdateSpecType.sql`, `Board_Web_Search.sql`.

## New Files

### Root and build configuration

| File | Likely owner / purpose | Intentional? |
|---|---|---|
| `Directory.Build.props` | Prior test/build configuration | Likely yes |
| `$null` | Unusual filename; purpose not established | Yes unless proven otherwise; preserved |

### Tests

| File | Likely owner / purpose | Intentional? |
|---|---|---|
| `tests/Regression/Regression.csproj` | Makes the regression suite independently runnable | Yes |

### Reports and QA metadata (30 before this snapshot)

`Board_Contact_RootCause_Priority.md`, `Board_Schema_Validation_Report.md`,
`Codex_Handoff.md`, `Contact_Board_QA_Report.md`, `Contact_Schema_Validation_Report.md`,
`Converter_Architecture.md`, `ConverterRules.md`, `Coverage.md`, `DeadCode.md`,
`Developer_Handoff.md`, `HighImpactFixes.md`, `MissingFeatures.md`,
`MSSQL_PG_Mapping.md`, `NextCommits.md`, `ParserAudit2.md`, `ParserRisk.md`,
`PerformanceHotspots.md`, `ProcedureDifficulty.md`, `ProtectedFiles.md`,
`Rank3_Candidate_QA.md`, `Rank4_Candidate_QA.md`, `Rank5_Candidate_QA.md`,
`RegexInventory.md`, `RegressionMatrix.md`, `RemainingFailures.md`,
`RemainingSchema_QA.md`, `ROI_Backlog.md`, `fix-contact-tasks.json`, `fix-log.md`,
and `fix-tasks.json`.

These appear to be intentional analysis, handoff, validation, prioritization, and task-tracking artifacts from prior agents. They are not owned by this inventory step.

### Scratch tooling and extracted data (11)

`board_fails.json`, `contact_fails.json`, `extract_failing_lines.ps1`,
`extract_failing_lines_full.ps1`, `generate_report.ps1`,
`run_contact_schema_runner.ps1`, `run_contact_validation.ps1`,
`run_schema_runner.ps1`, `scan_contact_errors.ps1`, `scan_errors.ps1`,
and `test_board_schema.ps1` under `scratch/`.

These appear intentional: they form the extraction, schema-runner, scanning, and report-generation toolchain that produced the QA artifacts.

### New generated SQL

- Board: `reports/board_failing_sql/Board_GetContentSetting.sql` (1 file).
- Contact: all 87 SQL files currently under `reports/contact_failing_sql/`.

The Contact set spans the three `Contact_*` procedures and 84 `Contacts_*` procedures reported by `git status --short`. It appears to be an intentionally generated failure corpus supporting Contact QA and root-cause analysis. These are generated outputs and should not be edited directly.

## Future Commit Boundary

Before any implementation commit, isolate the pre-existing converter/test work from the next rank. A future commit should include only changes deliberately made for that rank plus its newly regenerated QA/report artifacts. Do not sweep the current worktree into that commit.
