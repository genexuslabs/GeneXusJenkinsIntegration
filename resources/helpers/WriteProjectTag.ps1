param (
    [string] $ROOT = $(throw "miss script root"),
    [string] $HEAD = $(throw "miss tag header"),
    [string] $value = $(throw "miss tag new value")
)
$ConfigPath = "$ROOT\resources\project.json"
if(Test-Path -path $ConfigPath)
{
    $ConfigFile = Get-Content -Path $ConfigPath | ConvertFrom-Json
    $ConfigFile.$HEAD  = $value
    $ConfigFile | ConvertTo-Json | Out-File $ConfigPath
    Write-Output((Get-Date -Format G) + " INFO write $HEAD tag") | Tee-Object -FilePath $JLOG -Append -Verbose
}
else {
    Write-Output((Get-Date -Format G) + " ERROR missing project.json in $PSScriptRoot") | Tee-Object -FilePath $JLOG -Append -Verbose
    Write-Host -NoNewLine 'missing project.json in $PSScriptRoot';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    throw "missing project.json in $ConfigPath"
}