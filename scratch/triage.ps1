# triage.ps1
$bugs = Get-Content -Path E:\pg_converter_ui\scratch\converter_bugs.txt
$bootstrap = Get-Content -Path E:\pg_converter_ui\reports\schema_snapshots\inventory_v2\bootstrap_pg_inventory.csv
$runtime = Get-Content -Path E:\pg_converter_ui\reports\schema_snapshots\inventory_v2\runtime_pg_inventory.csv

# Create hashset of all table names in PG
$pgTables = New-Object System.Collections.Generic.HashSet[string]([System.StringComparer]::OrdinalIgnoreCase)
$pgColumns = New-Object System.Collections.Generic.HashSet[string]([System.StringComparer]::OrdinalIgnoreCase)

foreach ($line in $bootstrap + $runtime) {
    if ($line -match '"TABLE","public","([^"]+)"') {
        [void]$pgTables.Add($Matches[1])
    }
    if ($line -match '"COLUMN","public","([^"]+)\.([^"]+)"') {
        [void]$pgColumns.Add("$($Matches[1]).$($Matches[2])")
    }
}

$results = @()
$counts = @{
    "REAL_CONVERTER_BUG" = 0
    "PARENT_TABLE_MISSING" = 0
    "PARENT_COLUMN_MISSING" = 0
    "INTENTIONALLY_SKIPPED" = 0
    "NAME_NORMALIZATION_ISSUE" = 0
    "TYPE_MAPPING_ISSUE" = 0
    "DEPENDENCY_ORDER_ISSUE" = 0
    "NEED_MANUAL_REVIEW" = 0
}

$tableCounts = @{}
$kindCounts = @{}

foreach ($bug in $bugs) {
    if ($bug -match '^\|\s*Classification') { continue }
    if ($bug -match '^\|\s*---') { continue }
    if ($bug -match '^\|\s*CONVERTER_BUG\s*\|\s*128\s*\|') { continue }
    
    # Format: | ObjectKind | Schema | ObjectName | ParentTable | ColumnName | ...
    $parts = $bug.Split('|') | ForEach-Object { $_.Trim() }
    if ($parts.Length -lt 6) { continue }
    
    $kind = $parts[1]
    $name = $parts[3]
    $parent = $parts[4]
    $column = $parts[5]
    
    $classification = "NEED_MANUAL_REVIEW"
    
    if (-not $pgTables.Contains($parent)) {
        $classification = "PARENT_TABLE_MISSING"
    }
    elseif ($column -and -not $pgColumns.Contains("$parent.$column")) {
        $classification = "PARENT_COLUMN_MISSING"
    }
    else {
        # Check specific bug classes
        if ($kind -eq "DEFAULT" -and ($name -like "*NoteId*" -or $name -like "*NEWID*")) {
            $classification = "INTENTIONALLY_SKIPPED" # NEWID() is skipped intentionally
        }
        elseif ($name -like "sysdiagrams*" -or $parent -eq "sysdiagrams") {
            $classification = "INTENTIONALLY_SKIPPED" # sysdiagrams is system table
        }
        else {
            $classification = "REAL_CONVERTER_BUG"
        }
    }
    
    $counts[$classification]++
    $tableCounts[$parent]++
    $kindCounts[$kind]++
    
    $results += [PSCustomObject]@{
        Kind = $kind
        Name = $name
        Parent = $parent
        Column = $column
        Classification = $classification
    }
}

# Generate details list
$details = ""
foreach ($cat in $counts.Keys | Sort-Object) {
    $details += "### $cat ($($counts[$cat]))`n"
    $list = $results | Where-Object { $_.Classification -eq $cat }
    if ($list.Count -eq 0) {
        $details += "None.`n`n"
    } else {
        foreach ($item in $list) {
            $details += '- **' + $item.Kind + '** on `' + $item.Parent + '` (`' + $item.Name + '`'
            if ($item.Column) { $details += ', column: `' + $item.Column + '`' }
            $details += ')' + "`n"
        }
        $details += "`n"
    }
}

# Output summary report
$report = @"
# Remaining Converter Bug Triage Report

## 1. Executive Summary

- **Total Items Triaged**: $($results.Count)
- **Triage Breakdown**:
$( $counts.Keys | ForEach-Object { "  - **$_**: $($counts[$_])" } | Out-String )

## 2. Top Affected Tables
$( $tableCounts.Keys | Sort-Object { $tableCounts[$_] } -Descending | Select-Object -First 10 | ForEach-Object { "  - **$_**: $($tableCounts[$_]) items" } | Out-String )

## 3. Top Affected Object Kinds
$( $kindCounts.Keys | Sort-Object { $kindCounts[$_] } -Descending | ForEach-Object { "  - **$_**: $($kindCounts[$_]) items" } | Out-String )

## 4. Classifications Details

$details

## 5. Conclusion & Recommendations
**NEED VERIFICATION**. Most of the remaining primary/foreign keys and constraints are missing in the current target database due to the historic bugs in the converter (which did not emit primary key constraints for identity/serial columns, and omitted defaults for NEWID()). 
Now that the converter rules have been corrected, a full **rebuild** of the `pg_converter_runtime_test` database is recommended to verify that these constraints compile and deploy correctly in the next phase.
"@

$report | Out-File -FilePath E:\pg_converter_ui\reports\remaining_converter_bug_triage.md -Encoding utf8
Write-Host "Triage complete. Report written to reports/remaining_converter_bug_triage.md"
