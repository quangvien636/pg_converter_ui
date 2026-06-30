# test_board_schema.ps1
$npgsqlDll = "C:\Users\Admin\.nuget\packages\npgsql\8.0.5\lib\net8.0\Npgsql.dll"
if (Test-Path $npgsqlDll) {
    Add-Type -Path $npgsqlDll
} else {
    Write-Error "Npgsql.dll not found at $npgsqlDll."
    exit 1
}

$pgHost     = "221.148.141.4"
$pgPort     = 5432
$pgUser     = "postgres"
$pgPassword = "crewcloud@core1@3$5^"
$pgDatabase = "pg_converter_runtime_test"

$connString = "Host=$pgHost;Port=$pgPort;Database=$pgDatabase;Username=$pgUser;Password=$pgPassword;Timeout=30"
$conn = New-Object Npgsql.NpgsqlConnection($connString)
$conn.Open()

$objectsDir = "E:\pg_converter_ui\reports\production-validation-artifacts-20260629_135736\objects"
$files = Get-ChildItem -Path $objectsDir -Filter *.sql

$boardTables = $files | Where-Object { $_.Name -match "Table" -and $_.Name -match "Board" } | Sort-Object Name
$boardConstraints = $files | Where-Object { $_.Name -match "Constraint" -and $_.Name -match "Board" } | Sort-Object Name
$boardIndexes = $files | Where-Object { $_.Name -match "Index" -and $_.Name -match "Board" } | Sort-Object Name

Write-Output "--- Testing Board Tables ---"
$tableResults = @()
foreach ($file in $boardTables) {
    $name = $file.Name
    $sql = Get-Content $file.FullName -Raw
    $status = "PASS"
    $errorMsg = ""
    
    $tableName = $name -replace '^\d+_dbo_Table_', '' -replace '\.sql$', ''
    try {
        $dropCmd = $conn.CreateCommand()
        $dropCmd.CommandText = "DROP TABLE IF EXISTS public.`"$tableName`" CASCADE;"
        $dropCmd.ExecuteNonQuery() | Out-Null
    } catch {}

    try {
        $cmd = $conn.CreateCommand()
        $cmd.CommandText = $sql
        $cmd.ExecuteNonQuery() | Out-Null
    } catch {
        $status = "FAIL"
        $errorMsg = $_.Exception.Message
    }
    
    $tableResults += [PSCustomObject]@{
        Name = $tableName
        Status = $status
        Error = $errorMsg
    }
}

Write-Output "--- Testing Board Constraints ---"
$constraintResults = @()
foreach ($file in $boardConstraints) {
    $name = $file.Name
    $sql = Get-Content $file.FullName -Raw
    $status = "PASS"
    $errorMsg = ""

    if ($sql -match '^\s*--\s*TODO\s*:\s*Constraint\b') {
        $status = "STUB (Not converted)"
        $errorMsg = "Stub file / Not converted"
    } else {
        try {
            $cmd = $conn.CreateCommand()
            $cmd.CommandText = $sql
            $cmd.ExecuteNonQuery() | Out-Null
        } catch {
            $status = "FAIL"
            $errorMsg = $_.Exception.Message
        }
    }
    
    $constraintResults += [PSCustomObject]@{
        Name = $name -replace '^\d+_dbo_Constraint_', '' -replace '\.sql$', ''
        Status = $status
        Error = $errorMsg
    }
}

Write-Output "--- Testing Board Indexes ---"
$indexResults = @()
foreach ($file in $boardIndexes) {
    $name = $file.Name
    $sql = Get-Content $file.FullName -Raw
    $status = "PASS"
    $errorMsg = ""

    try {
        $cmd = $conn.CreateCommand()
        $cmd.CommandText = $sql
        $cmd.ExecuteNonQuery() | Out-Null
    } catch {
        $status = "FAIL"
        $errorMsg = $_.Exception.Message
    }
    
    $indexResults += [PSCustomObject]@{
        Name = $name -replace '^\d+_dbo_Index_', '' -replace '\.sql$', ''
        Status = $status
        Error = $errorMsg
    }
}

$conn.Close()

# Generate schema validation report
$reportPath = "E:\pg_converter_ui\reports\Board_Schema_Validation_Report.md"
$md = New-Object System.Text.StringBuilder
$md.AppendLine("# Board_% Schema DDL Validation Report") | Out-Null
$md.AppendLine()
$md.AppendLine("This report contains the test results of deploying Board-related table DDLs, constraint DDLs, and index DDLs to the PostgreSQL test database.") | Out-Null
$md.AppendLine()

$md.AppendLine("## 1. Tables Deployment Summary") | Out-Null
$md.AppendLine()
$md.AppendLine("| Table Name | Status | Error Details |") | Out-Null
$md.AppendLine("|------------|--------|---------------|") | Out-Null
foreach ($r in $tableResults) {
    $md.AppendLine("| `$($r.Name)` | **$($r.Status)** | $($r.Error) |") | Out-Null
}
$md.AppendLine()

$md.AppendLine("## 2. Constraints Deployment Summary") | Out-Null
$md.AppendLine()
$md.AppendLine("| Constraint Name | Status | Error Details |") | Out-Null
$md.AppendLine("|-----------------|--------|---------------|") | Out-Null
foreach ($r in $constraintResults) {
    $md.AppendLine("| `$($r.Name)` | **$($r.Status)** | $($r.Error) |") | Out-Null
}
$md.AppendLine()

$md.AppendLine("## 3. Indexes Deployment Summary") | Out-Null
$md.AppendLine()
$md.AppendLine("| Index Name | Status | Error Details |") | Out-Null
$md.AppendLine("|------------|--------|---------------|") | Out-Null
if ($indexResults.Count -eq 0) {
    $md.AppendLine("No separate index DDL files found for Board tables.") | Out-Null
} else {
    foreach ($r in $indexResults) {
        $md.AppendLine("| `$($r.Name)` | **$($r.Status)** | $($r.Error) |") | Out-Null
    }
}
$md.AppendLine()

[System.IO.File]::WriteAllText($reportPath, $md.ToString(), [System.Text.Encoding]::UTF8)
Write-Output "Successfully wrote Board Schema validation report to $reportPath"
