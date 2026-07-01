# compile_test.ps1
$connString = "Host=221.148.141.4;Port=5432;Database=pg_converter_runtime_test;Username=postgres;Password=crewcloud@core1@3$5^;Timeout=30"
$sqlPath = "E:\pg_converter_ui\reports\contact_failing_sql\Contacts_SaveAddressInfo.sql"
$sql = [System.IO.File]::ReadAllText($sqlPath)

$npgsqlPath = (Get-ChildItem -Path E:\pg_converter_ui -Filter "Npgsql.dll" -Recurse | Select-Object -First 1).FullName
if (!$npgsqlPath) {
    # check Temp
    $npgsqlPath = (Get-ChildItem -Path C:\Users\Admin\AppData\Local\Temp -Filter "Npgsql.dll" -Recurse | Select-Object -First 1).FullName
}

if ($npgsqlPath) {
    Write-Output "Loading Npgsql from $npgsqlPath"
    Add-Type -Path $npgsqlPath
} else {
    Write-Error "Could not find Npgsql.dll"
    exit 1
}

$conn = New-Object Npgsql.NpgsqlConnection($connString)
try {
    $conn.Open()
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = $sql
    $cmd.ExecuteNonQuery()
    Write-Output "SUCCESS: Compiled successfully!"
} catch [System.Exception] {
    Write-Output "ERROR occurred during compilation:"
    $ex = $_.Exception
    Write-Output ("Message: " + $ex.Message)
    if ($ex.GetType().Name -eq "PostgresException" -or $ex.GetType().BaseType.Name -eq "PostgresException") {
        Write-Output ("SqlState: " + $ex.SqlState)
        Write-Output ("MessageText: " + $ex.MessageText)
        Write-Output ("Position: " + $ex.Position)
        Write-Output ("InternalPosition: " + $ex.InternalPosition)
        Write-Output ("Where: " + $ex.Where)
        Write-Output ("Hint: " + $ex.Hint)
    }
} finally {
    if ($conn) { $conn.Close() }
}
