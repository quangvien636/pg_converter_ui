# generate_report.ps1
$json = Get-Content -Path E:\pg_converter_ui\reports\runtime_validation_results.json | ConvertFrom-Json

$results = @()
$counts = @{
    "RUNTIME_PASS" = 0
    "RUNTIME_FAIL" = 0
    "BLOCKED_NEED_DATA" = 0
    "BLOCKED_NEED_SIGNATURE" = 0
    "BLOCKED_SIDE_EFFECT_UNSAFE" = 0
    "NEED_BUSINESS_VALIDATION" = 0
}

$failDetails = ""

foreach ($r in $json) {
    # Determine classification
    # Status: 0 = PASS, 1 = FAIL, 2 = BLOCKED
    $statusStr = "NEED_BUSINESS_VALIDATION"
    if ($r.Status -eq 0) {
        $statusStr = "RUNTIME_PASS"
    } elseif ($r.Status -eq 2) {
        if ($r.ErrorMessage -like "*set-valued function called in context*") {
            $statusStr = "BLOCKED_NEED_SIGNATURE"
        } else {
            $statusStr = "BLOCKED_NEED_DATA"
        }
    } else {
        $statusStr = "RUNTIME_FAIL"
        
        $suspectedCause = "Unknown database mismatch"
        $isConverterBug = "No (Database schema / type discrepancy)"
        
        if ($r.ErrorMessage -like "*ambiguous*") {
            $suspectedCause = "Ambiguous column reference (parameter name matches table column)"
            $isConverterBug = "Yes"
        } elseif ($r.ErrorMessage -like "*does not exist*") {
            $suspectedCause = "Missing function, sequence, or table relation dependency"
            $isConverterBug = "No"
        } elseif ($r.ErrorMessage -like "*operator does not exist*") {
            $suspectedCause = "Implicit type casting mismatch (e.g. integer vs varchar)"
            $isConverterBug = "Yes"
        } elseif ($r.ErrorMessage -like "*of type*but expression is of type*") {
            $suspectedCause = "Explicit type mismatch on insert/update assignment"
            $isConverterBug = "Yes"
        }
        
        $failDetails += '### `' + $r.Name + '`' + "`n"
        $failDetails += '- **Input Test Used**: `' + $r.Input + '`' + "`n"
        $failDetails += '- **Error Message**: `' + $r.ErrorMessage + '`' + "`n"
        $failDetails += '- **Suspected Cause**: ' + $suspectedCause + "`n"
        $failDetails += '- **Is Converter Bug**: ' + $isConverterBug + "`n`n"
    }
    
    $counts[$statusStr]++
}

# Output report
$md = @"
# Standardized Runtime Smoke Test Report

## 1. Executive Summary

- **Total Routines Tested**: $($json.Count)
- **Triage Breakdown**:
  - **RUNTIME_PASS**: $($counts['RUNTIME_PASS'])
  - **RUNTIME_FAIL**: $($counts['RUNTIME_FAIL'])
  - **BLOCKED_NEED_SIGNATURE**: $($counts['BLOCKED_NEED_SIGNATURE'])
  - **BLOCKED_NEED_DATA**: $($counts['BLOCKED_NEED_DATA'])
  - **BLOCKED_SIDE_EFFECT_UNSAFE**: 0
  - **NEED_BUSINESS_VALIDATION**: 0

## 2. Failure Details (RUNTIME_FAIL)

$failDetails

## 3. Conclusion & Recommendations
- **Overall Status**: **NEED VERIFICATION** (Some procedures fail execution due to parameter/column name collisions or casting differences).
- **Casting Mismatches**: Converter rules should be refined to add automatic parameter qualification and type-cast handlers (e.g. `::integer` or explicit `CAST`).
"@

$md | Out-File -FilePath E:\pg_converter_ui\reports\runtime_smoke_test_standardized.md -Encoding utf8
Write-Host "Standardized report generated at reports/runtime_smoke_test_standardized.md"
