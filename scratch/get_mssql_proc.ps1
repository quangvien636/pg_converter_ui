# get_mssql_proc.ps1
$server = "221.148.141.4,14233"
$database = "CrewCloud_Company_Bootstrap"
$user = "dazone"
$pass = "crewcloud12!@";

$connStr = "Server=$server;Database=$database;User Id=$user;Password=$pass;TrustServerCertificate=True"
$conn = New-Object System.Data.SqlClient.SqlConnection($connStr)

$procName = $args[0]
if (!$procName) {
    Write-Error "Please specify a procedure name"
    exit 1
}

try {
    $conn.Open()
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = "SELECT definition FROM sys.sql_modules WHERE object_id = OBJECT_ID('dbo.' + @name)"
    $p = $cmd.Parameters.AddWithValue("@name", $procName)
    $def = $cmd.ExecuteScalar()
    if ($def) {
        Write-Output "=== ORIGINAL MSSQL DEFINITION FOR $procName ==="
        Write-Output $def
    } else {
        Write-Error "Procedure $procName not found"
    }
} catch {
    Write-Error $_.Exception.Message
} finally {
    $conn.Close()
}
