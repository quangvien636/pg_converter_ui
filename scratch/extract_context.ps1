$files = @(
    @("Contacts_GetContactsTrashList", 57068),
    @("Contacts_SaveAddressInfo", 27770),
    @("Contacts_SaveAddressInfo_Web", 29355),
    @("Contacts_SaveArrange", 4631),
    @("Contacts_SaveArrangeLike", 4647),
    @("Contacts_SaveContactsForOutlook", 8792),
    @("Contacts_UpdateUserInfo", 29143)
)
foreach ($f in $files) {
    $name = $f[0]; $pos = $f[1]
    $path = "E:\pg_converter_ui\reports\contact_failing_sql\$name.sql"
    if (Test-Path $path) {
        $content = [System.IO.File]::ReadAllText($path)
        if ($pos -gt $content.Length) { $pos = $content.Length }
        $pre = $content.Substring(0, $pos)
        $lines = $pre -split "\r?\n"
        $lineNo = $lines.Count
        $allLines = $content -split "\r?\n"
        Write-Output "=================================================="
        Write-Output "FILE: $name (Line $lineNo, Pos $pos)"
        Write-Output "=================================================="
        $start = [Math]::Max(0, $lineNo - 8)
        $end = [Math]::Min($allLines.Count - 1, $lineNo + 8)
        for ($i = $start; $i -le $end; $i++) {
            $prefix = if ($i + 1 -eq $lineNo) { ">>> " } else { "    " }
            Write-Output ("{0}{1:D4}: {2}" -f $prefix, ($i + 1), $allLines[$i])
        }
    } else {
        Write-Output "File not found: $path"
    }
}
