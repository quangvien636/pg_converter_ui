# debug_conversion.ps1
$projectPath = "E:\pg_converter_ui\pg_converter_ui.csproj"
$dllPath = "E:\pg_converter_ui\bin\Debug\net10.0-windows\pg_converter_ui.dll"

# Load assembly
Add-Type -Path $dllPath

$mssql = @"
CREATE PROCEDURE dbo.TestDrop
AS
BEGIN
    DROP TABLE #Temp
END
"@

$obj = New-Object pg_converter_ui.DbObject("TestDrop", [pg_converter_ui.ObjectType]::Procedure, $mssql, $true, "OK")

# Let's inspect the phases of Converter.Convert using reflection or by looking at the steps.
# Since we cannot easily trace internal private methods, we can test some of the regexes.
# Or we can just call Converter.Convert and print the final result.
$pg = [pg_converter_ui.Converter]::Convert($obj, "postgres")
Write-Output "=== FINAL PG CONVERTED OUTPUT ==="
Write-Output $pg
