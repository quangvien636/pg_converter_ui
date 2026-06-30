# run_post_commit_qa.ps1
# Repeatable QA script to run immediately after Claude commits.

$baselineNUnitPass = 20
$baselineBoardPass = 140
$baselineContactPass = 107

Write-Host "=== Step 1: Building Release ==="
$buildOutput = dotnet build e:\pg_converter_ui\pg_converter_ui.csproj -c Release
$buildStatus = "PASS"
if ($LASTEXITCODE -ne 0) {
    $buildStatus = "FAIL"
    Write-Error "Build failed!"
}

Write-Host "=== Step 2: Running NUnit Regression Tests ==="
$nunitOutput = dotnet test e:\pg_converter_ui\tests\Regression\Regression.csproj
$nunitPass = 0
$nunitFail = 0
$nunitText = $nunitOutput -join "`n"
if ($nunitText -match 'Passed!\s+-\s+Failed:\s+(\d+),\s+Passed:\s+(\d+)') {
    $nunitFail = [int]$Matches[1]
    $nunitPass = [int]$Matches[2]
} else {
    Write-Warning "Could not parse NUnit test results!"
}

Write-Host "=== Step 3: Running Board Procedure Validation ==="
$boardOutput = dotnet run --project C:\Users\Admin\AppData\Local\Temp\PgConverterBoardRunner\PgConverterBoardRunner.csproj
$boardPass = 0
$boardFail = 0
$boardText = $boardOutput -join "`n"
if ($boardText -match '(?s)Compile PASS\s+:\s+(\d+).+?Compile FAIL\s+:\s+(\d+)') {
    $boardPass = [int]$Matches[1]
    $boardFail = [int]$Matches[2]
} else {
    Write-Warning "Could not parse Board validation results!"
}

Write-Host "=== Step 4: Running Contact Procedure Validation ==="
$contactOutput = dotnet run --project C:\Users\Admin\AppData\Local\Temp\PgConverterContactRunner\PgConverterContactRunner.csproj
$contactPass = 0
$contactFail = 0
$contactText = $contactOutput -join "`n"
if ($contactText -match '(?s)Compile PASS\s+:\s+(\d+).+?Compile FAIL\s+:\s+(\d+)') {
    $contactPass = [int]$Matches[1]
    $contactFail = [int]$Matches[2]
} else {
    Write-Warning "Could not parse Contact validation results!"
}

# Calculations
$nunitDelta = $nunitPass - $baselineNUnitPass
$boardDelta = $boardPass - $baselineBoardPass
$contactDelta = $contactPass - $baselineContactPass

$nunitRegressions = $nunitFail
$boardRegressions = if ($boardPass -lt $baselineBoardPass) { $baselineBoardPass - $boardPass } else { 0 }
$contactRegressions = if ($contactPass -lt $baselineContactPass) { $baselineContactPass - $contactPass } else { 0 }

$recommendation = "Proceed to next ROI rank."
if ($nunitRegressions -gt 0 -or $boardRegressions -gt 0 -or $contactRegressions -gt 0 -or $buildStatus -eq "FAIL") {
    $recommendation = "⚠️ ROLLBACK REQUIRED due to detected regressions or build failures."
}

# Generate Report
$report = @"
# Post-Commit QA Automation Report

**Date:** $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")  
**Target Commit:** $(git log -1 --format="%H (%s)" 2>`$null)

---

## 1. Validation Checklist Status
- [x] Build Release: **$buildStatus**
- [x] NUnit Tests: **$($nunitPass) PASS / $($nunitFail) FAIL**
- [x] Board% Procedures: **$($boardPass) PASS / $($boardFail) FAIL**
- [x] Contact% Procedures: **$($contactPass) PASS / $($contactFail) FAIL**

---

## 2. Comparison Metrics

| Metric Suite | Baseline PASS | Post-Commit PASS | Delta | Regressions | Status |
|--------------|---------------|------------------|-------|-------------|--------|
| **NUnit Tests** | $baselineNUnitPass | $nunitPass | $nunitDelta | $nunitRegressions | $(if ($nunitRegressions -gt 0) { "FAIL" } else { "PASS" }) |
| **Board% Procs** | $baselineBoardPass | $boardPass | $boardDelta | $boardRegressions | $(if ($boardRegressions -gt 0) { "FAIL" } else { "PASS" }) |
| **Contact% Procs** | $baselineContactPass | $contactPass | $contactDelta | $contactRegressions | $(if ($contactRegressions -gt 0) { "FAIL" } else { "PASS" }) |

---

## 3. Recommendation
**$recommendation**

---

## 4. Run Details
* **Build Status:** $buildStatus
* **Detected Regressions:**
  * NUnit: $nunitRegressions
  * Board%: $boardRegressions
  * Contact%: $contactRegressions
"@

$reportPath = "E:\pg_converter_ui\reports\PostCommit_QA.md"
[System.IO.File]::WriteAllText($reportPath, $report, [System.Text.Encoding]::UTF8)
Write-Host "Successfully generated Post-Commit QA report at $reportPath"
