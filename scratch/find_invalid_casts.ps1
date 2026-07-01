$c = [System.IO.File]::ReadAllText('E:\pg_converter_ui\reports\contact_failing_sql\Contacts_GetContactsTrashList.sql')
$matches = [regex]::Matches($c, 'CAST\([^)]+,[^)]+\)')
foreach ($m in $matches) {
    Write-Output ("Found: " + $m.Value + " at index " + $m.Index)
}
