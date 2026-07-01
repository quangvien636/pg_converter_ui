# search_trash.ps1
$server = "221.148.141.4,14233"
$database = "CrewCloud_Company_Bootstrap"
$user = "dazone"
$pass = "crewcloud12!@";

$connStr = "Server=$server;Database=$database;User Id=$user;Password=$pass;TrustServerCertificate=True"
$conn = New-Object System.Data.SqlClient.SqlConnection($connStr)

try {
    $conn.Open()
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = "SELECT definition FROM sys.sql_modules WHERE object_id = OBJECT_ID('dbo.Contacts_GetContactsTrashList')"
    $def = $cmd.ExecuteScalar()
    if ($def) {
        $lines = $def -split "\r?\n"
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match "SearchMode = '7'") {
                Write-Output "Lines around Match:"
                $start = [Math]::Max(0, $i - 10)
                $end = [Math]::Min($lines.Count - 1, $i + 10)
                for ($j = $start; $j -le $end; $j++) {
                    $prefix = if ($j -eq $i) { ">>> " } else { "    " }
                    Write-Output ("{0}{1:D4}: {2}" -f $prefix, ($j + 1), $lines[$j])
                }
            }
        }
    }
} catch {
    Write-Error $_.Exception.Message
} finally {
    $conn.Close()
}
