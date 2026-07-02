if ([string]::IsNullOrWhiteSpace($env:PG_RUNTIME_CONNECTION)) {
    throw "Set PG_RUNTIME_CONNECTION. Credentials must not be stored in scripts."
}

dotnet run --project (Join-Path $PSScriptRoot "..\qa\RuntimeValidationRunner\RuntimeValidationRunner.csproj")
exit $LASTEXITCODE
