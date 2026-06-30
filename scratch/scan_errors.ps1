$sqlFiles = Get-ChildItem -Path reports/board_failing_sql -Filter *.sql
$failures = @()

foreach ($file in $sqlFiles) {
    $procName = $file.BaseName
    $lines = Get-Content $file.FullName
    $errors = @()

    for ($i = 0; $i -lt $lines.Length; $i++) {
        $line = $lines[$i]
        $trimmed = $line.Trim()
        
        # Skip comment lines completely
        if ($trimmed.StartsWith("--") -or $trimmed.StartsWith("/*") -or $trimmed.StartsWith("*")) {
            continue
        }

        # 1. Check for unconverted TOP
        # Ignore comments like /* TOP 1 */
        if ($line -match '(?<!/\*\s*)(?i)\bTOP\b(?!\s*\*\/)') {
            $errors += [PSCustomObject]@{
                category = "unconverted_top"
                line = $i + 1
                snippet = $trimmed
            }
        }

        # 2. Check for unconverted NOLOCK
        if ($line -match '(?i)\bNOLOCK\b') {
            $errors += [PSCustomObject]@{
                category = "unconverted_nolock"
                line = $i + 1
                snippet = $trimmed
            }
        }

        # 3. Check for unconverted ISNULL
        if ($line -match '(?i)\bISNULL\s*\(') {
            $errors += [PSCustomObject]@{
                category = "unconverted_isnull"
                line = $i + 1
                snippet = $trimmed
            }
        }

        # 4. Check for unconverted GETDATE
        if ($line -match '(?i)\bGETDATE\b') {
            $errors += [PSCustomObject]@{
                category = "unconverted_getdate"
                line = $i + 1
                snippet = $trimmed
            }
        }

        # 5. Check for unconverted @@ROWCOUNT
        if ($line -match '(?i)@@ROWCOUNT\b') {
            $errors += [PSCustomObject]@{
                category = "unconverted_rowcount"
                line = $i + 1
                snippet = $trimmed
            }
        }

        # 6. Check for unconverted temp tables (#temp)
        if ($line -match '#\w+') {
            $errors += [PSCustomObject]@{
                category = "unconverted_temp_table"
                line = $i + 1
                snippet = $trimmed
            }
        }

        # 7. Check for unconverted variables (@var)
        # Note: we exclude email addresses or common characters if any
        if ($line -match '@\w+') {
            $errors += [PSCustomObject]@{
                category = "unconverted_variable"
                line = $i + 1
                snippet = $trimmed
            }
        }

        # 8. Check for unconverted CONVERT
        if ($line -match '(?i)\bCONVERT\s*\(') {
            $errors += [PSCustomObject]@{
                category = "unconverted_convert"
                line = $i + 1
                snippet = $trimmed
            }
        }

        # 9. Check for unconverted CHARINDEX
        if ($line -match '(?i)\bCHARINDEX\s*\(') {
            $errors += [PSCustomObject]@{
                category = "unconverted_charindex"
                line = $i + 1
                snippet = $trimmed
            }
        }

        # 10. Check for unconverted STUFF
        if ($line -match '(?i)\bSTUFF\s*\(') {
            $errors += [PSCustomObject]@{
                category = "unconverted_stuff"
                line = $i + 1
                snippet = $trimmed
            }
        }

        # 11. Check for unconverted FOR XML
        if ($line -match '(?i)\bFOR\s+XML\b') {
            $errors += [PSCustomObject]@{
                category = "unconverted_for_xml"
                line = $i + 1
                snippet = $trimmed
            }
        }

        # 12. Check for double semicolons (;;)
        if ($line -match ';;') {
            $errors += [PSCustomObject]@{
                category = "double_semicolon"
                line = $i + 1
                snippet = $trimmed
            }
        }

        # 13. Check for unconverted brackets []
        if ($line -match '\[\w+\]|\[dbo\]') {
            $errors += [PSCustomObject]@{
                category = "unconverted_brackets"
                line = $i + 1
                snippet = $trimmed
            }
        }
    }

    if ($errors.Count -gt 0) {
        $failures += [PSCustomObject]@{
            procedure = $procName
            source_file = "reports/board_failing_sql/$procName.sql"
            errors = $errors
        }
    }
}

$output = @{
    failures = $failures
}

$output | ConvertTo-Json -Depth 10 | Out-File -FilePath reports/fix-tasks.json -Encoding utf8
Write-Output "Successfully wrote $($failures.Count) procedure failures to reports/fix-tasks.json"
