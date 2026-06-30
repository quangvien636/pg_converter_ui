$connString = "Server=221.148.141.4,14233;Database=CrewCloud_Company_Bootstrap;User ID=dazone;Password=crewcloud12!@;Encrypt=False;TrustServerCertificate=True"
$conn = New-Object System.Data.SqlClient.SqlConnection($connString)
$conn.Open()
$cmd = $conn.CreateCommand()
$cmd.CommandText = @"
SELECT OBJECT_NAME(object_id) AS Name 
FROM sys.sql_modules 
WHERE (definition LIKE '%FOR XML RAW%' 
   OR definition LIKE '%FOR XML AUTO%' 
   OR definition LIKE '%ROOT%' 
   OR definition LIKE '%ELEMENTS%')
  AND definition LIKE '%FOR XML%'
ORDER BY Name
"@
$reader = $cmd.ExecuteReader()
while($reader.Read()) {
    Write-Output $reader.GetValue(0)
}
$conn.Close()
