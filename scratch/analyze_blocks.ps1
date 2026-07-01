# analyze_blocks.ps1
$sqlPath = "E:\pg_converter_ui\reports\contact_failing_sql\Contacts_SaveArrange.sql"
$lines = Get-Content $sqlPath
for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i].Trim()
    if ($line.StartsWith("--")) { continue }
    if ($line -match '^\b(BEGIN|END|IF|ELSE|END IF|LOOP|END LOOP)\b' -or $line -match '\b(THEN|LOOP)$') {
        Write-Output ("{0:D4}: {1}" -f ($i + 1), $line)
    }
}
