$sourceDir = "C:\Users\Admin\AppData\Local\Temp\PgConverterBoardRunner"
$targetDir = "C:\Users\Admin\AppData\Local\Temp\PgConverterContactRunner"

if (!(Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir | Out-Null
}

Copy-Item "$sourceDir\PgConverterBoardRunner.csproj" "$targetDir\PgConverterContactRunner.csproj" -Force
$programText = Get-Content "$sourceDir\Program.cs" -Raw

# Modify Program.cs to focus on Contact_ / Contacts_ procedures
$programText = $programText -replace 'reportPath = Path\.Combine\(outputDir, "Board_Procedure_Validation\.md"\);', 'reportPath = Path.Combine(outputDir, "Contact_Procedure_Validation.md");'
$programText = $programText -replace '=== Board_% Procedure Validation Runner ===', '=== Contact_% Procedure Validation Runner ==='
$programText = $programText -replace '=== Board_% Summary ===', '=== Contact_% Summary ==='
$programText = $programText -replace 'Converting Board_% procedures\.\.\.', 'Converting Contact_% procedures...'
$programText = $programText -replace 'Deploying Board_% functions to PostgreSQL\.\.\.', 'Deploying Contact_% functions to PostgreSQL...'
$programText = $programText -replace '"Board_Procedure_Validation\.md"', '"Contact_Procedure_Validation.md"'
$programText = $programText -replace '"board_failing_sql"', '"contact_failing_sql"'
$programText = $programText -replace 'proname LIKE ''board_%''', "(proname LIKE 'contact_%' OR proname LIKE 'contacts_%')"
$programText = $programText -replace '# Board_% Procedure Validation Report', '# Contact_% Procedure Validation Report'
$programText = $programText -replace 'Total Board_% procedures', 'Total Contact_% procedures'
$programText = $programText -replace '## 2. Board_% Procedure Feature Matrix', '## 2. Contact_% Procedure Feature Matrix'

# Replace the procedure filtering logic
$oldFilter = @'
var boardProcs = allObjects
    .Where(o => o.Type == ObjectType.Procedure &&
                o.Name.StartsWith("Board_", StringComparison.OrdinalIgnoreCase))
    .OrderBy(o => o.Name)
    .ToList();
'@

$newFilter = @'
var boardProcs = allObjects
    .Where(o => o.Type == ObjectType.Procedure &&
                (o.Name.StartsWith("Contact_", StringComparison.OrdinalIgnoreCase) ||
                 o.Name.StartsWith("Contacts_", StringComparison.OrdinalIgnoreCase)))
    .OrderBy(o => o.Name)
    .ToList();
'@

$programText = $programText.Replace($oldFilter, $newFilter)

[System.IO.File]::WriteAllText("$targetDir\Program.cs", $programText, [System.Text.Encoding]::UTF8)
Write-Output "Successfully set up Contact validation runner at $targetDir"
